Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D725F11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E56EC433C7;
	Mon, 11 Sep 2023 15:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445821;
	bh=gsrV6wd+rteFlqvyrJ1AzCZfvhGGa/BrnYzxucFb9/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yatbgZhuGhx69zfPtB3ILKqlcVyrj5BJf3GUcz9W5Agvhb2htbqhRYuii93h6xR44
	 0AlrUJgbJBKwnY5OavxjOYUr/Gf5BG2XIm4BH47Bo+ZUAZFMCgRpbvI78wP8OLnv4g
	 KLQRbkpevQfyQgP/Ds5uhqCEfaJQwKLJKVFUGluQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 457/600] docs: ABI: fix spelling/grammar in SBEFIFO timeout interface
Date: Mon, 11 Sep 2023 15:48:10 +0200
Message-ID: <20230911134647.143262989@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 2cd9ec2a51474d4c0b4d2a061f2de7da34eff476 ]

Correct spelling problems as identified by codespell.
Correct one grammar error.

Fixes: 9a93de620e0a ("docs: ABI: testing: Document the SBEFIFO timeout interface")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eddie James <eajames@linux.ibm.com>
Cc: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20230710052305.29611-1-rdunlap@infradead.org
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-fsi-devices-sbefifo | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-fsi-devices-sbefifo b/Documentation/ABI/testing/sysfs-bus-fsi-devices-sbefifo
index 531fe9d6b40aa..c7393b4dd2d88 100644
--- a/Documentation/ABI/testing/sysfs-bus-fsi-devices-sbefifo
+++ b/Documentation/ABI/testing/sysfs-bus-fsi-devices-sbefifo
@@ -5,6 +5,6 @@ Description:
 		Indicates whether or not this SBE device has experienced a
 		timeout; i.e. the SBE did not respond within the time allotted
 		by the driver. A value of 1 indicates that a timeout has
-		ocurred and no transfers have completed since the timeout. A
-		value of 0 indicates that no timeout has ocurred, or if one
-		has, more recent transfers have completed successful.
+		occurred and no transfers have completed since the timeout. A
+		value of 0 indicates that no timeout has occurred, or if one
+		has, more recent transfers have completed successfully.
-- 
2.40.1



