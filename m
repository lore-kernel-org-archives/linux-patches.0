Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E3724E4C3;
	Thu,  2 Jul 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011755; cv=none; b=c3JUUys3a35povinLeNa2OqJg4D3cv0CCNgo+d07ju4aXNZb0Pn9EpGPlSIOIkbUTz3OBmBGhMUnb9sqZXrQ/2/YCSzGf+L8w8en+9btrEs6LLXza4DHC4Z3NOb1gOF6HD9dnURrChTujW9+QwMTxq7kNXNHXfSOZB9A1vLkt20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011755; c=relaxed/simple;
	bh=LEIHuGpBkPifW+c977gHLWKfq2RWTrl2z6prHspTl5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRjXZobveXVbTYH2DpOUefwUw28+bnxx6vqG4U3xPrY9mjFzAiDzVzwsI5iWGD7fjzZPxB5jAXZzLDJyZy0KAtwmFs/Hc7rNYbFvYaezHhozXcLu3idnPZdG6D21MYLmWtLSa92mU/izA3NMmhYLgKBW3gtHRmlPcwv4Lllk+ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5ENeV7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5ENeV7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0411F000E9;
	Thu,  2 Jul 2026 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011753;
	bh=lpFd/8s0B0wgAteJlQGacon42IpMf1v1zxuKfom7rLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5ENeV7AFKpyMGGzhQDnBCvCNuoOhblLyrzl1dd4dj/tP2dGojOJszEk6MmUjEIte
	 ePQId6A8tVV6o96/xolGb32LYU5RRbOXylZ+566G8uymqBe1gid+mL/uYEZgr+53o0
	 aAvIIdi2RFC+BtVn+YBBIyVL//fXI/wc+noy4GtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 7.1 120/120] apparmor: advertise the tcp fast open fix is applied
Date: Thu,  2 Jul 2026 18:21:56 +0200
Message-ID: <20260702155115.461698579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit 2f6701a5ce6257ae7a64ddc6d89d0a08d2a034f8 upstream.

The fix for tcp-fast-open ensures that the connect permission is being
mediated correctly but it didn't add an artifact to the feature set to
advertise the fix is available. Add an artifact so that the test suite
can identify if the fix has not been properly applied or a new
unexpected regression has occurred.

Fixes: 4d587cd8a7215 ("apparmor: mediate the implicit connect of TCP fast open sendmsg")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -22,12 +22,14 @@
 
 struct aa_sfs_entry aa_sfs_entry_network[] = {
 	AA_SFS_FILE_STRING("af_mask",	AA_SFS_AF_MASK),
+	AA_SFS_FILE_BOOLEAN("tcp-fast-open",		1),
 	{ }
 };
 
 struct aa_sfs_entry aa_sfs_entry_networkv9[] = {
 	AA_SFS_FILE_STRING("af_mask",	AA_SFS_AF_MASK),
 	AA_SFS_FILE_BOOLEAN("af_unix",	1),
+	AA_SFS_FILE_BOOLEAN("tcp-fast-open",		1),
 	{ }
 };
 


