Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AEA8F4B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10453C4339E
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677778833;
	bh=rneHHZqdlZq083XY/byM+L2OkuQ63XyWZGUM74hoORM=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=zP69lIaY2TyaWYhCLKYVzRmLxjzDSRvO/e17UQqJNsF44AuuYrZrH9zn/k6lP5hRT
	 HL1Oze19Hmi6V7Tt2lqwV9pEU78520fLWNyqn6hrM6zckCX1Eg/Qb6+gVkCstxmO4T
	 M9finLa4fJvYLdNeEZpInLfHUaUsSEyviwIk54q0=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 02 Mar 2023 12:40:20 -0500
Subject: [PATCH v13 3/3] Another commit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20220825-test-endpoint-send-2-v13-3-047ec9929bec@linuxfoundation.org>
References: <20220825-test-endpoint-send-2-v13-0-047ec9929bec@linuxfoundation.org>
In-Reply-To: <20220825-test-endpoint-send-2-v13-0-047ec9929bec@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.13-dev-14a61
X-Developer-Signature: v=1; a=openpgp-sha256; l=631;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=rneHHZqdlZq083XY/byM+L2OkuQ63XyWZGUM74hoORM=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFIY7vfv9OJrbIzJsNvAHfXM9NNd0Zkvr2pOb+Y4p+t0n
 PvNwvY5HaUsDGJcDLJiiixl+2I3BRU+9JBL7zGFmcPKBDKEgYtTACYilsnI8GjhdUbnAoVmgRs3
 p12fuFEhpXx62cYGl7f3dp2Mcct0+8LIsHpOnNl3zgcaL/sjw+8vj52Y6ppczrWr/+TJ8HyZtFQ
 RdgA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is junkiest.

Cc: Bubba Babootich <devnull@kernel.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
 README | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/README b/README
index 669ac7c32292..45a8981c222f 100644
--- a/README
+++ b/README
@@ -16,3 +16,5 @@ several of them using the Restructured Text markup notation.
 Please read the Documentation/process/changes.rst file, as it contains the
 requirements for building and running the kernel, and information about
 the problems which may result by upgrading your kernel.
+
+I added this line and edited it.

-- 
2.39.2

