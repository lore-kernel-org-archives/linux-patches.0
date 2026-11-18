Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041297;
	b=hIFGvw0sK+PgmYCxgGj+Di83LwVo/S7hKiiPfjaW558OUJoK8fVGFnX1euoShC5baCHT
	 vzMUt+6MVWH6K16fio8ThamVf14zhtSrk/ys2GRuuzORWnf1yTO1SM71yB0QK41tMGXgv
	 E0JZ+GoZ2fRKvr5fa9LVkvyMx7ZBZ7J75NDK2tISxXr6gHbj4osE0XjV+/Xh5GWED15i+
	 zm4eYkf+6y5DMvIPI6+aiLlOQyZ9GKvsnGNUfHWUfxb5IRY0MrzRBpLw65m0bxAEJ8WJZ
	 wOJ2EZev+RPhgFTvL7DSgOO2Qi+Bzmn4scOzv2i0zrvzotV3Q05S/qS49L16Ddkd7tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xPrBAU/5LEv86uF1K1iNWFU3PEXGV1pS5sN2W+qr4jo=;
	b=RZyzgH1G5SqBpIZDGxnjQLUsjLaw1molRh5ITPePuUsWUYQAHe2v/j2Y+lQDG988YPyX
	 u3Aqg/aSdq4k6ymgahm6goAPp1eTBHK4IFy/VjSwdG9NWsAT7+bqmP2ygqC6Hd36DAiTx
	 B4VKs0qFIuRY50+u0f7I7SxUNtnkBKuiw3HBw0oti3SDSf05blqeRqR/VN/M65U20CIqN
	 SwxsxP7fxfJ5AxrMqDBqtlUm57NHtoNaQbd1g0QEXSQliHgh5odt16ErTclcStBsokDgi
	 ues6chgqSr0veF/pUXPFTck7whOsBhIygcAgNmq7DANaqODmidpior0nWMpNI8kWy2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZwOZMS0O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A095606A32C;
	Wed, 18 Nov 2026 22:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZwOZMS0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6231F000C4;
	Wed, 18 Nov 2026 22:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041296;
	bh=xPrBAU/5LEv86uF1K1iNWFU3PEXGV1pS5sN2W+qr4jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwOZMS0O5ihP8jHfsVSyTwetUzcLa+ey6sorOIs1yzmbDbfm6a/BQLn0NoMSPUrhf
	 tzpPfv7I9PeLFRys8ZDaEzFAY9ey/9AZiJa8tnWwhnKgdBQI5b+I7tkrTjNEglYxZ8
	 pgKfTrryepyel9bHjDx/aOgXBlOByB//hOQaVKS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Cheng <leo-cheng@vip.qq.com>,
	Michael Walle <mwalle@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2722/3318] nvmem: layouts: onie-tlv: fix device_node reference leak in error path
Date: Wed, 18 Nov 2026 15:55:44 +0100
Message-ID: <20261118150442.507024213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Cheng <leo-cheng@vip.qq.com>

[ Upstream commit 9d44e80151dd360fad6155f36b6bfa57efb0f2f5 ]

onie_tlv_add_cells() takes a reference on the child node via
of_get_child_by_name() for each parsed TLV and passes it to
nvmem_add_one_cell() as cell.np. On success the created cell entry
adopts that reference and releases it later via of_node_put(); on
failure nvmem_add_one_cell() does not consume it, so the caller still
owns it, but the error path only puts layout before returning, leaking
the child node reference.

Put cell.np on the error path as well. of_node_put(NULL) is a no-op, so
this is safe even when of_get_child_by_name() returned NULL.

Fixes: d3c0d12f6474 ("nvmem: layouts: onie-tlv: Add new layout driver")
Signed-off-by: Leo Cheng <leo-cheng@vip.qq.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/layouts/onie-tlv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/layouts/onie-tlv.c b/drivers/nvmem/layouts/onie-tlv.c
index 607821721c245..c391bfa0b10fa 100644
--- a/drivers/nvmem/layouts/onie-tlv.c
+++ b/drivers/nvmem/layouts/onie-tlv.c
@@ -128,6 +128,7 @@ static int onie_tlv_add_cells(struct device *dev, struct nvmem_device *nvmem,
 
 		ret = nvmem_add_one_cell(nvmem, &cell);
 		if (ret) {
+			of_node_put(cell.np);
 			of_node_put(layout);
 			return ret;
 		}
-- 
2.53.0



