Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A055234AAF3;
	Tue, 11 Nov 2025 01:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823779; cv=none; b=J249C4cNJxi40ZiqQ38az0P1FrYTzcME74/fdpdmdjVn/LMlkYUQBYb5FLLnYu/PvmH8psD94e5DliWqHuOhPpD8LF8sPpTGk9jTaJwZC7lSdGEMC/w8bgpBit7W5ksen5E8DRJc3AzEc71/DOaQZYNp1Qxk/tuEOT4ATq9tYLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823779; c=relaxed/simple;
	bh=UvRTTJrLvNnz5lIxIcEKMqo54eWT58cSyAIvoxJdG/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHTcWmscjiryaopo3KntrDS/PD2JrqZJ1CvTT4M0VvZNiqhufcBG0TOu1YTzKRVqTMtYr7IZEbjjO8ckypU6UBwKcklGuF6Lpdqi7FNSh3V/QxywqfmSBrbZ4kDpj/QqtuGfrPACD7jMEyEJ6qZ7EAkE09lgNK9hayH6GDnFlTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1G4i5tHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1G4i5tHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D825C19422;
	Tue, 11 Nov 2025 01:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823779;
	bh=UvRTTJrLvNnz5lIxIcEKMqo54eWT58cSyAIvoxJdG/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1G4i5tHC4bla+7qxHOmsnXkUDs56TDwiY7Yu+/p//Tgtn+NyKGjbCXf4aWz/N78oq
	 n+DofIntuOPjqtfZEIGL/OqiIAf/fki4AnalRycfk6gy50cjob7Hb9Ixan2E5mCtho
	 otWp8rZlGNSC3qWptW3NqVuSZ3pCHjfGtLjBjV4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Hans de Goede <hansg@kernel.org>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/565] media: ov08x40: Fix the horizontal flip control
Date: Tue, 11 Nov 2025 09:42:54 +0900
Message-ID: <20251111004534.042248846@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Hao Yao <hao.yao@intel.com>

[ Upstream commit c7df6f339af94689fdc433887f9fbb480bf8a4ed ]

The datasheet of ov08x40 doesn't match the hardware behavior.
0x3821[2] == 1 is the original state and 0 the horizontal flip enabled.

Signed-off-by: Hao Yao <hao.yao@intel.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Tested-by: Hans de Goede <hansg@kernel.org> # ThinkPad X1 Carbon Gen 12 & Gen 13
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov08x40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov08x40.c b/drivers/media/i2c/ov08x40.c
index 1fe8e9b584f80..83a957182cb5f 100644
--- a/drivers/media/i2c/ov08x40.c
+++ b/drivers/media/i2c/ov08x40.c
@@ -1564,7 +1564,7 @@ static int ov08x40_set_ctrl_hflip(struct ov08x40 *ov08x, u32 ctrl_val)
 
 	return ov08x40_write_reg(ov08x, OV08X40_REG_MIRROR,
 				 OV08X40_REG_VALUE_08BIT,
-				 ctrl_val ? val | BIT(2) : val & ~BIT(2));
+				 ctrl_val ? val & ~BIT(2) : val | BIT(2));
 }
 
 static int ov08x40_set_ctrl_vflip(struct ov08x40 *ov08x, u32 ctrl_val)
-- 
2.51.0



