Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D989222301;
	Thu, 16 Jul 2026 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211646; cv=none; b=Ep39L3++RKnJhBmmU9xe2NsHTtZY2iN6j3qYOytbhZBlo8i80+7RXvnjqL5/nj+oOlVakRi65Yp3GUbNK/+CzQzcnL5rf/sluueR8WncYbYacm6mnY5E3t1KxmA9pEUxN6HFQ5Upu8hupRkS1DSgeRE2nNrVFk67kNI46usBq44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211646; c=relaxed/simple;
	bh=t6PLFltMORas/FUuEGoAIETC3Ogj2jcUPjpVI08rsu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQMIKtBvV0ZBALagJSB2g6YLOg7pk/vyiBqnb4PpklnKGc2Mv3UwvK2j3nGPlwCKeAmte8vm41vKld7Sn66XcMUyYBKiv0RHWm6nVFGKn7QnVmAkweZSm/DbEM4TtqJtpSeyYzLsdV1+xIXmHvkmQ6agOd3DM6cGT164sjKkvcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+pVLBE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+pVLBE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730F81F000E9;
	Thu, 16 Jul 2026 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211645;
	bh=KQ1buEr3ZwiYCWf+8QYEpYTZkhzY9uHV4YpVFTlexNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+pVLBE/0Cqkh4OcB/AUQX68eboe1pcEXbwY6se4cVg4NiDyfQyaEFz7TyLoRgBYg
	 yaXnwU3/WxGWtab0DrUdLJP6TM+WwPoHsAx8IzGr/0Vw2cMQhN3gsgRFGuUWyUNs76
	 LBnqayPKF+zpZ17tBpBb/3QOXmAVB45XMQ8Q6nO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/349] apparmor: advertise the tcp fast open fix is applied
Date: Thu, 16 Jul 2026 15:29:20 +0200
Message-ID: <20260716133033.894930427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 2f6701a5ce6257ae7a64ddc6d89d0a08d2a034f8 ]

The fix for tcp-fast-open ensures that the connect permission is being
mediated correctly but it didn't add an artifact to the feature set to
advertise the fix is available. Add an artifact so that the test suite
can identify if the fix has not been properly applied or a new
unexpected regression has occurred.

Fixes: 4d587cd8a7215 ("apparmor: mediate the implicit connect of TCP fast open sendmsg")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -21,6 +21,7 @@
 
 struct aa_sfs_entry aa_sfs_entry_network[] = {
 	AA_SFS_FILE_STRING("af_mask",	AA_SFS_AF_MASK),
+	AA_SFS_FILE_BOOLEAN("tcp-fast-open",		1),
 	{ }
 };
 


