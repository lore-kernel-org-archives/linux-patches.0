Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0D46DD10;
	Tue, 23 Jan 2024 02:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975407; cv=none; b=RXw/hlg7qrMIAXpWOakQrqihzqpyUUUiwXRvbngA9rl2Xx57e0dfqlP9MxOCAbrv3tlCF77jOmliW4NhPvPRmU19DU+cfX8c2xcqZqwNbTvf6tcFEMQNGSlZDnVtif11NcLI05GXW3Pri6DuX7ldMuP+WdaEkd8Nwq8yRe/k+Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975407; c=relaxed/simple;
	bh=+l8iZyOfREXCxpiuw7Gupg/sZMV5c6Pc1tqJPSEU+Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCiMvt6GTA7BDc/cbiJBq0Bo7BU67SCPsDd4xc2JkX+AnGkJFyLKSRo1ISPV0dp42NIX/JJYgYsiaAOzsI+Hn+N+oZ3Ni4IjtvAUEMxrkkRH9RRQwYToknxJc/CNm7ixBqu9bh58Trc+b0eOUOsM69+hM/m4mPTMrsc+QwbBets=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZGasgIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZGasgIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90575C43394;
	Tue, 23 Jan 2024 02:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975407;
	bh=+l8iZyOfREXCxpiuw7Gupg/sZMV5c6Pc1tqJPSEU+Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZGasgIXMMV6cmCe2HavCHs68YgV3W3O6c6nfnvtg29yYJDVU2c9KWdGMrR15o0nD
	 zoW7lIFLJCe3gfZzAiNY94H/Va4dh3HE2k8A2NrU6EZkCKfU1v6Sng0hrOk+a0SYrK
	 SX4UWYoKItZ5WhvlmHMApH6c3Sl++6Elz8qf22pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 368/583] Revert "usb: typec: class: fix typec_altmode_put_partner to put plugs"
Date: Mon, 22 Jan 2024 15:56:59 -0800
Message-ID: <20240122235823.275430556@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -266,7 +266,7 @@ static void typec_altmode_put_partner(st
 	if (!partner)
 		return;
 
-	adev = &altmode->adev;
+	adev = &partner->adev;
 
 	if (is_typec_plug(adev->dev.parent)) {
 		struct typec_plug *plug = to_typec_plug(adev->dev.parent);
@@ -496,8 +496,7 @@ static void typec_altmode_release(struct
 {
 	struct altmode *alt = to_altmode(to_typec_altmode(dev));
 
-	if (!is_typec_port(dev->parent))
-		typec_altmode_put_partner(alt);
+	typec_altmode_put_partner(alt);
 
 	altmode_id_remove(alt->adev.dev.parent, alt->id);
 	kfree(alt);


