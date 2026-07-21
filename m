Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A094147141B;
	Tue, 21 Jul 2026 20:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664883; cv=none; b=Srwar7c8ECGfJMFbw+Xx3OZp4YDdTYXHe2LlHYGjrypTZ11HRJhYC/QV+ccT4pRuaWYaCm5t3LP6RHbN++3sdtxOOEVh53cCSbfCx8sRnhOzFUoufFVbqdFdXmXkf05E2/ykKCX7+PIF2FK+Pj+y7iF1pzsUBC9WeiOHbr85qbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664883; c=relaxed/simple;
	bh=CHmCZtQZgy6tq98mMCmc34euEnpWUvT20kKO7oiN49U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzEYpz5HcuWqucuGXTmaaRz5a7pNniOP8nSs+7cUDclA7IddWUY1L3l1/NttfArtQBGV8bMn3BwmwHhqQGbYGpgeTUmlWEzIymASqvU0gamK/IrMCf0z65Yc4roQx1bqPHtYgQk0Z6QWF6udQtpf49Zjdr5RjYkBR09NdpHE9Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxpYmwnz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxpYmwnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132CC1F000E9;
	Tue, 21 Jul 2026 20:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664880;
	bh=oDUak9owZxq45zPGG6/gpCf/Jp2sWdgVt0+UHgvCfgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxpYmwnzRcasoZ3bGjkScywOoRGkfpcgP2fUdk15QU7u68D3V4HnIJhf50LZ1fD0T
	 YFz2WBkGsG/8XJh8rDs4k889wObTelzyYTqQom82y/HdOKENnf4am+3FGtTauyl5ow
	 wrn4L7cXUA9MMmp5tGGNJo6ECnrNYSju+d/Kv5sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0040/1266] apparmor: advertise the tcp fast open fix is applied
Date: Tue, 21 Jul 2026 17:07:57 +0200
Message-ID: <20260721152442.700123606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


