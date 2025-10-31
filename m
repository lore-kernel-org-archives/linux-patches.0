Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA0330B03;
	Fri, 31 Oct 2025 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919550; cv=none; b=qnfFv12tI1Kezf+oOcpYi+3f6WZpmd7NZlAbMup9ZmSACg/9G5XQ+XBT5GoT1cLhnc3cmTgZobPYCoLf/Dp2LY2udXHsBbnjz7neXwcTZM3DlifO1KxQs+PrS2o166lRxcwjw0LW5qdNrNbW/wB+rBjfYHHqxWB/qE5d4YlwGWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919550; c=relaxed/simple;
	bh=ziB1K4ioLHJD92mj1XqwqmBgXedF3fEVpp41cysf+j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEWXsVk7O2T9uqSukEHrkU2vT7HotWtpS3cBSS3vA0o6kYM20BiYZFEdHTXoAGBYhyXAl7FkNw6XAmgg7WO+59Bb7kckdlfaZXyglbFvxwF286Hq2XFACTfIO62VYdeXOnLkDHokeKzo9oUV1/hwBop2BNvSfIveSw1MBxB9EcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBwowGdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBwowGdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A00EC4CEE7;
	Fri, 31 Oct 2025 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919549;
	bh=ziB1K4ioLHJD92mj1XqwqmBgXedF3fEVpp41cysf+j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBwowGdMn3q3HWBa+9N1NUw9lnHiMqWzvOpWh6ok8VpD3hCw5HDObE8PbEusxvCPa
	 /Xf18viJ0+PYG38v1B+lfIqu51ifGa3BiXWrNXJDsgp5tXo1vAJ2KMd8yeqUDKMQ0q
	 FDykkpqGaJL27fUbkaTtTdoHajTnkuJhp4cJCv9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 16/35] EDAC: Fix wrong executable file modes for C source files
Date: Fri, 31 Oct 2025 15:01:24 +0100
Message-ID: <20251031140043.950320962@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 71965cae7db394ff5ba3b2d2befe4e136ceec268 ]

Three EDAC source files were mistakenly marked as executable when adding the
EDAC scrub controls.

These are plain C source files and should not carry the executable bit.
Correcting their modes follows the principle of least privilege and avoids
unnecessary execute permissions in the repository.

  [ bp: Massage commit message. ]

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250828191954.903125-1-visitorckw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ecs.c        | 0
 drivers/edac/mem_repair.c | 0
 drivers/edac/scrub.c      | 0
 3 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/edac/ecs.c
 mode change 100755 => 100644 drivers/edac/mem_repair.c
 mode change 100755 => 100644 drivers/edac/scrub.c

diff --git a/drivers/edac/ecs.c b/drivers/edac/ecs.c
old mode 100755
new mode 100644
diff --git a/drivers/edac/mem_repair.c b/drivers/edac/mem_repair.c
old mode 100755
new mode 100644
diff --git a/drivers/edac/scrub.c b/drivers/edac/scrub.c
old mode 100755
new mode 100644
-- 
2.51.0



