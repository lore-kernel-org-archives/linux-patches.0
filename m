Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024980;
	b=2GM+CAszCmdB+TIL3fe4jyvgl/c1Lfd3hL3a/oCTXAZKvlEaALD3Emv6d61z+Y9r2azl
	 2PQq/4bu6V9liI5O7+lwuK7vhZbqHoJ+gQVvSFs1Ob3Hh77NEm1VhZ7M4vqhufRJBpxpC
	 LSPnmgZWoCECoZXutZyfWQ4LmJshd3xdIaYrV1wd7tnNrNUEmOlRS3rnQac2i/oxuc3rT
	 uVPAJkOjbk426ETrvaOM1C+DNMHeGskhV4stQsfajga1Br9iLUaTgUROTts3ChT9pZe0t
	 YsfhOL5PNslYLhmkPhl9yj9nV7HefZCuDKGPFteNuu95ew2cLLHZ4wtM6dkDEjnH6ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W/Ijiuo/Ru3OePPXAYImmgWiyfO71OqemTotXkp0USc=;
	b=IXlY6Gdv7vpHxhseMqCcE21w5De96USsLRiPDWuuIdXK8xJ5I2B0MSD6Hsol7qkzWmJi
	 0sKrgkWD3XnKmzEL8DvSTzpRJBLQIrjybylF1xqc4nrxhYxwW3cbDkAn24nwYmXUqU4oh
	 P0Okz9ceIUEjDNjP49QRGm+s2AqGFRQVcQhqjXj6ZYtyAVN4Vjt9hGp7rWkZ6TUOYeSgZ
	 h+8KvwXjfsqYoB9M8BkM/tY/flqwnr2LCFERquOCJtO/cGSs/0SCGB+5+JV6Ztt3w/5yY
	 csw3ydbW6Qh4nOc5PHM9D145uO9dXENcV7d2hDHe48VCZrOE2bfvoD/5ztES35pxqMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gz+vVnMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D55D606A31C;
	Wed, 18 Nov 2026 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gz+vVnMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5EC1F000C4;
	Wed, 18 Nov 2026 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024980;
	bh=W/Ijiuo/Ru3OePPXAYImmgWiyfO71OqemTotXkp0USc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gz+vVnMsQXcCbshFv5fuu+X9zjRChRtR7kFpZ06RMjFyQgLPX7KaxipDeVVtKQgEa
	 5aezwNKVtw7Ha9GCmh2gADlNmPU261TRgwKbEdbcOl1Q5iH8fHq1iawVvw8LLCdchU
	 oJIbaiujOnTGTNflzoi07G5Qo82IukYKl3/kAZhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0866/2151] media: iris: fail firmware boot on invalid uc_region
Date: Wed, 18 Nov 2026 15:43:21 +0100
Message-ID: <20261118150153.759149944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit f301102c17f22f4a140bd9a50281473e6b782f0c ]

iris_vpu_boot_firmware() polls CTRL_STATUS while the firmware boots. When
the hardware reports an invalid uc_region setting, the poll loop breaks
early with count still below max_tries. The following timeout check
(count >= max_tries) is therefore false, so the function skips the error
return and falls through to return 0, reporting a successful boot. The
caller then enables host interrupts and proceeds to use firmware that
never came up, which can lead to unhandled timeouts or hardware hangs.

Return an error directly from the uc_region error path instead of breaking
out of the loop and reporting success.

Fixes: abf5bac63f68 ("media: iris: implement the boot sequence of the firmware")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vpu_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vpu_common.c b/drivers/media/platform/qcom/iris/iris_vpu_common.c
index a20565abef6a6..6fe266f63f641 100644
--- a/drivers/media/platform/qcom/iris/iris_vpu_common.c
+++ b/drivers/media/platform/qcom/iris/iris_vpu_common.c
@@ -124,7 +124,7 @@ int iris_vpu_boot_firmware(struct iris_core *core)
 		ctrl_status = readl(core->reg_base + CTRL_STATUS);
 		if ((ctrl_status & CTRL_ERROR_STATUS__M) == 0x4) {
 			dev_err(core->dev, "invalid setting for uc_region\n");
-			break;
+			return -EINVAL;
 		}
 
 		usleep_range(50, 100);
-- 
2.53.0



