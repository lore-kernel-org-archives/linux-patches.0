Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00010A959
	for <patches@lists.linux.dev>; Fri, 23 Jun 2023 16:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5380BC433C9;
	Fri, 23 Jun 2023 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687539153;
	bh=WwUAoDe1qGuOfw155KXTYh/KRnfqrV4XWxHYNAtmomk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=xqU+XeCXX1XjR5+4zWeOFrc4L3Esonsf6y1ZIXQbbGJx+TD5yQfJKG0U/OwOnU8zR
	 y9q3j8jG1ngig11Vd+27SbSLzXXFyVxGBJi1wrdDPgY6gYfkTm8aBpwnF0bSRgVKke
	 ZhJs4dScw67L+XWvn+AG4jRWEH5Kfh84Bc7rXgw8=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 23 Jun 2023 12:52:06 -0400
Subject: [PATCH WIP 1/2] README: rename Linux to Lunix
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230623-test-resend-prefixes-v1-1-4fe9a056ff8c@linuxfoundation.org>
References: <20230623-test-resend-prefixes-v1-0-4fe9a056ff8c@linuxfoundation.org>
In-Reply-To: <20230623-test-resend-prefixes-v1-0-4fe9a056ff8c@linuxfoundation.org>
To: patches@lists.linux.dev
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
X-Mailer: b4 0.13-dev-87aac
X-Developer-Signature: v=1; a=openpgp-sha256; l=428;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=WwUAoDe1qGuOfw155KXTYh/KRnfqrV4XWxHYNAtmomk=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFKmnj2/92L3xyNxhlP1OblLxdTs2W7oLH2T+PG1neNhX
 UO3rV7rOkpZGMS4GGTFFFnK9sVuCip86CGX3mMKM4eVCWQIAxenAEzk2AqGfzZH9CZ5M/Qk8yRn
 T8nPSXDw0nnWc/NeUuDyBhu1588nMzH8M2JePeFiod+0V2b/UlcvfPCw6gHzYZ0m5Y2xngvW/7R
 m5gIA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Test commit, please ignore.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
 README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README b/README
index 669ac7c32292..c482329b5b58 100644
--- a/README
+++ b/README
@@ -1,4 +1,4 @@
-Linux kernel
+Lunix kernel
 ============
 
 There are several guides for kernel developers and users. These guides can

-- 
2.41.0

