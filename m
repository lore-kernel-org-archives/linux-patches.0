Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6FB12DDB0;
	Tue, 23 Jan 2024 01:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971731; cv=none; b=N/d+CCPT7p3MTHBSjyNPITcGl5RytfyHLf5v2d35nbRP6A9+HS+v2ZkUP244aGE/dybcntSixAMwj0SPM4YrKA2KZ2GEv2S6ZLEZD5+FVBbDRIaoGOpSg0FtvSWSDCyobXf+SAGzK2/65LahHAGDfJTC3qS/doSaEWfvnxeniQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971731; c=relaxed/simple;
	bh=4O/R8J0QZY68JMkE9x0ZcJLIhYYnyASdU48ciF+Orlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtp2JOskY7VIlBsaZMdokob0lsEomVMETQqhwQXvM5fDKLiZvy6mo0ulU9P7/T5nzsvBHLh0am8YL5TrV7f7kOGStJomC4mvZ3BWirHNz0SVe6Uv0PkjufbtdOTi0MYIZcEam2/WOyJh+p0yPpjkVpuXr0JUHjRzzct6HgEVkH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoeYyVnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoeYyVnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8890EC433F1;
	Tue, 23 Jan 2024 01:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971730;
	bh=4O/R8J0QZY68JMkE9x0ZcJLIhYYnyASdU48ciF+Orlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoeYyVnXdSFzk3AdUtG03vH0m/i2HviH843MxK+IWFw1qBIaCZmy+DfX6BjprN2Em
	 XZ3hShruXfh9HY2hk88LdCgei7rlTO9UkQOJnq2LCm5+Y50vhH/J8TqKoMNdLsZ0Y5
	 CuMAw8dWBIAb1FtYwercELnNI+G2UutbnaXsubYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 216/286] Revert "usb: typec: class: fix typec_altmode_put_partner to put plugs"
Date: Mon, 22 Jan 2024 15:58:42 -0800
Message-ID: <20240122235740.406258536@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 9c6b789e954fae73c548f39332bcc56bdf0d4373 upstream.

This reverts commit b17b7fe6dd5c6ff74b38b0758ca799cdbb79e26e.

That commit messed up the reference counting, so it needs to
be rethought.

Fixes: b17b7fe6dd5c ("usb: typec: class: fix typec_altmode_put_partner to put plugs")
Cc:  <stable@vger.kernel.org>
Cc: RD Babiera <rdbabiera@google.com>
Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Closes: https://lore.kernel.org/lkml/CAP-bSRb3SXpgo_BEdqZB-p1K5625fMegRZ17ZkPE1J8ZYgEHDg@mail.gmail.com/
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240102091142.2136472-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -194,7 +194,7 @@ static void typec_altmode_put_partner(st
 	if (!partner)
 		return;
 
-	adev = &altmode->adev;
+	adev = &partner->adev;
 
 	if (is_typec_plug(adev->dev.parent)) {
 		struct typec_plug *plug = to_typec_plug(adev->dev.parent);
@@ -424,8 +424,7 @@ static void typec_altmode_release(struct
 {
 	struct altmode *alt = to_altmode(to_typec_altmode(dev));
 
-	if (!is_typec_port(dev->parent))
-		typec_altmode_put_partner(alt);
+	typec_altmode_put_partner(alt);
 
 	altmode_id_remove(alt->adev.dev.parent, alt->id);
 	kfree(alt);


