Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CA7145B27;
	Tue, 23 Jan 2024 00:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969686; cv=none; b=A5NIi7J8npEucBqOsv8DvwURvn7AkM1Ys1HOqYClNfYYBYAtd6at+E9bXbv1+DWM2pkr2vpG8ZuQQcNFguvlP+5uQu+grn7aGGI90d8JP9M6ATxfD/f/KDZMwP/Y73F21J2UP75HWPfNtYs7g13DyAbqs7ImNuvjXuhtHFDGFJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969686; c=relaxed/simple;
	bh=GjCKWETSOCXkOC9yUO6ERDqrkev7197Atw5RZTUdEsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+cJPSGKOtpuCpkQgl9jsR41G0qi/1YucONsqz0IamIOTVfI6QTg9GQ0T315qvg1llpR5BKT60xHEDlH8aX9TPFJNeZl/tqMrS8m/PWafNgd21keMQA5vvoN3OSz0OAtS3aUVuczGQLHKcUEuhBXkpJxCxj6AU0kcwiGLX94DSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jvuY+wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jvuY+wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CD3C433F1;
	Tue, 23 Jan 2024 00:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969686;
	bh=GjCKWETSOCXkOC9yUO6ERDqrkev7197Atw5RZTUdEsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jvuY+wcmoclo0SxY/2LkbEnOf5z8tVGBXGJFSd8qJaYXzCM2ofjfu79LChYE+7BO
	 w0d4mA9bYJqK96dNnXcPywS1AxeNU2eqmGDBiD8LU7jKBH8TrhmP6OpDTlPNS9y5dS
	 DPa7iT5XtAsWpltaNTH2JIpRHj9epBtaowDXDkdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.7 405/641] Revert "usb: typec: class: fix typec_altmode_put_partner to put plugs"
Date: Mon, 22 Jan 2024 15:55:09 -0800
Message-ID: <20240122235830.652492892@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -267,7 +267,7 @@ static void typec_altmode_put_partner(st
 	if (!partner)
 		return;
 
-	adev = &altmode->adev;
+	adev = &partner->adev;
 
 	if (is_typec_plug(adev->dev.parent)) {
 		struct typec_plug *plug = to_typec_plug(adev->dev.parent);
@@ -497,8 +497,7 @@ static void typec_altmode_release(struct
 {
 	struct altmode *alt = to_altmode(to_typec_altmode(dev));
 
-	if (!is_typec_port(dev->parent))
-		typec_altmode_put_partner(alt);
+	typec_altmode_put_partner(alt);
 
 	altmode_id_remove(alt->adev.dev.parent, alt->id);
 	kfree(alt);


