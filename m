Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E01F6D17
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17822C341CE
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658339822;
	bh=mS6sd3AjdfDSNN9e5pc420kfdVHZtXRM7O6LJm/Fq/8=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=FkvHBGODmozgCmQ9e5Cr5APHy5D0hJLSzXZAY/I3e/igRuz1MCPJQKkMXilLUPBTr
	 gSGuNHCFDuKg6LqKta2EtlyMbruLPQFUL4bxZXGW8WkxrsBQJZy/QSVjMy5GMdcvEi
	 uaHlHcGkdsULTdbO39NkTtjR84UTsfD4ADWg0JtM=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 13:57:02 -0400
Subject: [PATCH v3 3/3] README: rename Linux to Kahlux
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220720-claim-for-kahless-v3-3-7874906a7515@linuxfoundation.org>
References: <20220720-claim-for-kahless-v3-0-7874906a7515@linuxfoundation.org>
In-Reply-To: <20220720-claim-for-kahless-v3-0-7874906a7515@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-e2b6f
X-Developer-Signature: v=1; a=openpgp-sha256; l=567;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=mS6sd3AjdfDSNN9e5pc420kfdVHZtXRM7O6LJm/Fq/8=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJuOL5tNl+v3trGLMFbb17A9OalsUpT52+zCxN5jgdckDeq
 MVHpKGVhEONikBVTZCnbF7spqPChh1x6jynMHFYmkCEMXJwCMJFFfxkZDndOOy7anjLx9vTwdTlOX8
 uVAuSiJ1r9rbTw2Si5PO3hA4Z/6hz7ZJTvpoU76rLHP1v4QWeefVfu/bM5E2/6LJ0vbybJCAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

The name speaks for itself!

Reviewed-by: General Martok <mricon@kernel.org>
Reviewed-by: Voq the Pale <konstantin.ryabitsev@linux.dev>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/README b/README
index 669ac7c32292..3a48a87cbc83 100644
--- a/README
+++ b/README
@@ -1,5 +1,5 @@
-Linux kernel
-============
+Kahlux kernel
+=============
 
 There are several guides for kernel developers and users. These guides can
 be rendered in a number of formats, like HTML and PDF. Please read

-- 
b4 0.10.0-dev-e2b6f
