Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044948;
	b=xFixZNuiVfNLrKRn6Kh8pa4PHE3rYodnaZ5dtxyQupGTtFMO8aJm3GD9XoN+JOEGXyQG
	 31Y40CHAMejIcnKrQgg/8d6CmMugV54Zqp5hTm+2WRp2Qn/5j1xTQuLAkSbrIHsEPKtBA
	 8HV9+UDQVzjetqVnZyoqp5lMLEMGVn3TKMqSCkisRM6OAfoWVSubZEyCOzsBD52X0Td3v
	 GYFG4veoSgKigARFCwaUdc/dYAsrMIZMHUgLQ7zSXbSXgqx2nyat4pgf9yYNGi1uwEZUY
	 jy5orTJs2TaTo25oB/8QznGzuk7kq9uNGs3ujpR4w5qQ9DX9yZx/t7NIBXboGEJ/C/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s57fSZaHw2OGPv/3nlGK73bhUU3CF4NDtUzwx5zeG8s=;
	b=A6eIm+kcN9Kv2ULx361qB4UPhS2IEHu9DkLld9jqZmsn4+uV476ScC2DL0zfp8M8lbCq
	 Dyo6yNEIR4qR+eXG+K9QjNJfGxe0m4Fu+PcreBJxaI0v3agbasvkMjWz6LvVPyiwdPW7u
	 LUDkAPHJyhRJDbrPg9NG56YN/hDbY4XgWML/Mxg1v+4X+LJb+eMCROEFckLR7WHsv3i/4
	 y2uy+O4b4JpOiBo0r4qFflAD1319gQWCQ6Yu0hHy19aGz96nF+E6sRb7ZqflgmW4OZKG/
	 TfyJ/WjOPujrbWsqY78rPrjwjAzn9xeByJ2v5H0fvV+zrMhkkazaSv4JDDnvjVrf6eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJ7snIbN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1BD606A325;
	Wed, 18 Nov 2026 23:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJ7snIbN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49031F000C4;
	Wed, 18 Nov 2026 23:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044948;
	bh=s57fSZaHw2OGPv/3nlGK73bhUU3CF4NDtUzwx5zeG8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJ7snIbNfVClljVhI5AKt2MKG7H8WQASd2XfRQKCL42rN0Om1PkmOw0PSFWI2Ensn
	 ghIaOjxkVqkoGJTjZFFTrge5QCOLusF4fjlwj9njqOhsq+xL9rm8cgrP85FyLBIVcn
	 PUFmk2H/ee3KfL++Cxw56s/2tw/rOHGuwG1I9coA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0749/2857] media: microchip-isc: fix PM runtime leak in AWB work handler
Date: Wed, 18 Nov 2026 15:29:43 +0100
Message-ID: <20261118150228.519997505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 21ad8225822a892c4c273bf1368d477a83a19dbb ]

Early return when streaming stops skips pm_runtime_put_sync(),
leaking the reference and preventing runtime suspend.

Fixes: 314c96e5203d ("media: atmel: atmel-isc-base: use mutex to lock awb workq from streaming")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index bb9c082764076..9e91e4d948a24 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -1471,7 +1471,7 @@ static void isc_awb_work(struct work_struct *w)
 	/* streaming is not active anymore */
 	if (isc->stop) {
 		mutex_unlock(&isc->awb_mutex);
-		return;
+		goto out_pm_put;
 	}
 
 	isc_update_profile(isc);
@@ -1482,6 +1482,7 @@ static void isc_awb_work(struct work_struct *w)
 	if (ctrls->awb)
 		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
 
+out_pm_put:
 	pm_runtime_put_sync(isc->dev);
 }
 
-- 
2.53.0



