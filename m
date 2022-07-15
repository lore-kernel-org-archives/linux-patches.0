Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4E84C8B
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 20:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADECDC341CA
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 20:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657915480;
	bh=vaUQ6bOHW506CYM4ruJkaHO+rYsxKUpW7uN0zImXbv8=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=vTcLA15eX8CQ8AFhm94vYYMY4PW/+yW8YrX1N52Wvxs7GOF/K+uY2t/2yTbkQLyxu
	 QjtBSA3KxB6nEEdNXyvxwyTPTjWe7CHavE+FBka2g0sY2fkW6f9gOLRd5ZmymehYJD
	 O+j6dEoEnAqBtLgR10sipg3vhOPepoAnZp2RAq/4=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 15 Jul 2022 16:04:40 -0400
Subject: [PATCH v3 1/3] Rename Linux into Kahlix
Message-Id: <20220707-my-new-branch-v3-1-feb2652699b2@linuxfoundation.org>
References: <20220707-my-new-branch-v3-0-feb2652699b2@linuxfoundation.org>
In-Reply-To: <20220707-my-new-branch-v3-0-feb2652699b2@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-05523
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Developer-Signature: v=1; a=openpgp-sha256; l=514;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=vaUQ6bOHW506CYM4ruJkaHO+rYsxKUpW7uN0zImXbv8=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIunoj4fEmprWvil1lTZnBVVh9ly2p5sa7ry67TV+/NFHxT
 qSPyoqOUhUGMi0FWTJGlbF/spqDChx5y6T2mMHNYmUCGMHBxCsBEpKIYGdb8mXD16C4Jud5JvEo8vk
 8SKpgvpZodbVjGynSoxjX0RQPDP6vcplSVMiWrO/2zvityzit6c7P6TuHsXUXbvTe+6hbfzQsA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I am using this series to test b4-submit
functionality.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/README b/README
index 669ac7c32292..663103a12dde 100644
--- a/README
+++ b/README
@@ -1,5 +1,5 @@
-Linux kernel
-============
+Kahlix kernel
+=============
 
 There are several guides for kernel developers and users. These guides can
 be rendered in a number of formats, like HTML and PDF. Please read

-- 
b4 0.10.0-dev-05523
