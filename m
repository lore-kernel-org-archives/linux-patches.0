Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B8D6026
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 19:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587A7C433C1;
	Tue, 26 Jul 2022 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658864796;
	bh=0D6vltEbcwj4cEsm92GX9VR2iprasU6PU/S9yFs9odg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=W/heZt26EN8YBovUGcKlYCsX+YphOzhJQLgXcJeS8ftvoJ1gLknDGEKykP0kiZUIo
	 lzjVQlEdZ8nzT75MqTXZFHH2y8tB9B8r/ghOwDk75SJKtd3SQE8KEsmNFlGtQlZwAs
	 eElRqGiqKhrI13t2Psl0CNwOa1amsbmK7BZhqPBs=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 15:46:27 -0400
Subject: [PATCH v1 1/3] Rename into Pumpkix
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220726-claim-for-great-pumpkin-v1-1-cba88581a0b0@linuxfoundation.org>
References: <20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org>
In-Reply-To: <20220726-claim-for-great-pumpkin-v1-0-cba88581a0b0@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658864796; l=449;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=0D6vltEbcwj4cEsm92GX9VR2iprasU6PU/S9yFs9odg=;
 b=v6WQ0irfeXEcOKqLYTqPCltTTDDPl9ZcgnrY6f5Ci8GrLB7C56C0lVmXaeGtamFl3NHGJsWD7GHd
 S/q+FW0fD315fLxaFGZHSL4VrW7Z4IlrlzF6cGF3ROXlDluBIMOV
X-Developer-Key: i=konstantin@linuxfoundation.org; a=ed25519;
 pk=fAfUubVyx9rNeSbf8qETNADGwWcptn+Ur6Aaf++c4AY=

Because why not.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/README b/README
index 669ac7c32292..4e9414583df9 100644
--- a/README
+++ b/README
@@ -1,5 +1,5 @@
-Linux kernel
-============
+Pumpkix kernel
+==============
 
 There are several guides for kernel developers and users. These guides can
 be rendered in a number of formats, like HTML and PDF. Please read

-- 
b4 0.10.0-dev-13c24
