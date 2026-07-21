Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0964D434E4F;
	Tue, 21 Jul 2026 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668059; cv=none; b=jmLVwGMyeqfPj2p4YoAs7T4IeJH//MTZzoWwvJWoYaUnc/m6BiFNumj2t9UOjENxKGRGL7g225FbyAxtey5T75WUkcDBXQsNPjhh2PS1WUbHrwcCJOOUFYTLcCsZuvYfa48ZyUHYkEGsm399SEtJdtWiBSVHAFe86tDAHN44MXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668059; c=relaxed/simple;
	bh=4EgXiygfl87/mbTLh8Mpoe+N9DcVUfldN9zKvA7oxk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+j7MK8FA5VbVA316aShzWDsKDV7Dfi2/Qksvif7hSiDf4ZfvjAJ+rTygXv06xD87fHSWJcd3pCzmQa+Wgpj/k3ENjjwIa+LZUMmX1DMaP0RuHpwrOxHvCr695Ygv1OmHC8/POp9nfWbdekZcKyne8y22uNPoEDb9s0ciROyvHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4FigMYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4FigMYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEAF1F000E9;
	Tue, 21 Jul 2026 21:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668057;
	bh=fbhtkU4tXm5jIkNmNdK/ztFZfa7tk5HTWOOwvfMm9KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4FigMYC0OjLg9sVOzLWGuhZbQUtwj9wXTnroW5sRBatPgTcJWx7eE7DoSL9Vgg3q
	 V+xR5RldiIKgSOzeQjqyf2BjLJtU/S1tzvpIlnfu+/NlOVxZI+Dw8/nb+tLLZLIIaR
	 xynpgPr5vhw/nF0pF6eRfxhJeMwubXQUckja8isk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0032/1067] apparmor: advertise the tcp fast open fix is applied
Date: Tue, 21 Jul 2026 17:10:33 +0200
Message-ID: <20260721152425.268496180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


