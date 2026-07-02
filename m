Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E01F2D0602;
	Thu,  2 Jul 2026 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011434; cv=none; b=rCwhAE0UDu/bhuHyeqJ4TIDSDBNZAskQ464oOYGfNSvoic/UwLkD4zzPVwYuHzOJ9lgEHR23uuCa2YFngCMrFg9jEZLUikh8SPHYEM25T0xHDt9Gd+AGGm/o8H7QycC/DxV7vdZF/lklpC6tOs0Q+5WlkPQGz0ETyLMQRLbo/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011434; c=relaxed/simple;
	bh=ucMAQJ1ltfeGCvKKDdO60Fq/51wgDsqBGPf30jIKkx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8VEVyekR8ljrpurL2CUO4b7PGnU0aS38gq9LkM8w28cpHy6WPtsNQ0nr0OrBtFeikN67R9NmXTS1RDi7+7PWkRdtUBRCYKR05rUiZlChf1/XB1ObzgeRSGGiNLBvwxSb7W7yMa696u+VIxhsdn0UEKjg/tVj1UKMgZtnyqfJ3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3lVnTqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3lVnTqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A806D1F000E9;
	Thu,  2 Jul 2026 16:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011433;
	bh=zwS2TxabWUt5zPpXyY2102Tk7kFlD1ehAdfa2bWAuSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3lVnTquUS7r8Ax8RGyzH5Ybv2+yOuBQtDhtyweKW0tL9HTtU9H/JxbIKI5jP6HzS
	 zSMk9OfXB/SqenaLpcIY+1j5un4bVwSLSapHQ16hSNQlSr4AswNXwIhnI5CvM4zRf/
	 ZyS0uNN4RMn7aGPtoSqJGIPGCaGFRXQXMxviyvqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.18 108/108] apparmor: advertise the tcp fast open fix is applied
Date: Thu,  2 Jul 2026 18:21:45 +0200
Message-ID: <20260702155114.351001718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


