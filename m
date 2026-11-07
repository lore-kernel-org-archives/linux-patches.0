Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064744;
	b=wdL9Gz3emxF8iPHqk4k9GIpw8H9+2/PUpBh20BC1WcS4l9orHP+O9DlkyjqKn/AYxZ68
	 N8gmZct72wZLoFSI05JrB9C1li79YcIvfXoKMafGpxF1RT0WdSUBJ5QE45NbNLhjIxeTl
	 tviogM+S3SGGy9NNuyr3LJb5zNGEAqyBVXCQarKg7ENO7mJRg02NvPzx17++VFd9hpI/4
	 mslRi6NT0ABSPVihu0+i8s+GgQnV8CFAMaMtx51buLhJSRNQtx7aSHPHeblvUzcui/wLw
	 rtZX/WKnWL/0DLKxAI/2nhoRHSb2s2wU34Nf9fk+oAgu/KpqSeHSNpQ3ALZ6ETaJVJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qi20VI8+sNWBNICvJQo2vY3Gx6INytMUPhZy/zkMpQ8=;
	b=tbaLOL98HuSagjQKuUdn8EJrxg6OWf+ijbmbTbkU3D7xLKqVzpGER1fl/NZ+Jj4uP1eI
	 DMAqt9T5DzoX7nalLcNOwspTl9IKcugJ+WwNnb3Z4sj0J8dR5GiU+dDxXkc+KF5JrF8NI
	 FZafER3qYfbyDzh2HehBXUiVjanNJrpjZ5y//NJkhdGArAHqm8O7gryeUwc91o2JP/nbZ
	 4hyH3cULmnFjlT/0r3WZEkWSRqTCed3aD2Nu81ULAsrJqH0b91/vu72F5z9IrDylY3w8a
	 9kUP8/fLUiKZgidjdxlBlPe7HhSR6oFh+mDS3Gujr5vu8iIx/BwjDllllLtLX1CdXbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmuBscKB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEE3606D81C;
	Sat,  7 Nov 2026 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmuBscKB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3EB1F0089F;
	Sat,  7 Nov 2026 15:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064743;
	bh=Qi20VI8+sNWBNICvJQo2vY3Gx6INytMUPhZy/zkMpQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmuBscKBTaa6ZpBlB/IEHm+8LbBEV5iK+kR8YEOCPmt8LVxfukcN+nGeyDWZqIcxI
	 j54xuUpejGBYs7wZNMPvLEhd8LU/a90hVpMatpzF8cUpF1HjFmJZguIkmo5/F0viLE
	 HvIlRWX8bF9T8SL0DMGW3fLMJu8tsLAPAPPPLlvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0719/1257] accel/qaic: Cancel Sahara read data work on removal
Date: Sat,  7 Nov 2026 08:50:15 -0500
Message-ID: <20261107134959.120394621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 018e5a021904707b91cecd77e7f759937ec04643 ]

Sahara removal cancels fw_work and dump_work, but leaves read_data_work
pending or running. The latter accesses the firmware and the device-managed
context and transfer buffer, which are released during removal.

Cancel read_data_work after fw_work, which can schedule it, and before
releasing the firmware. The MHI core suspends and resets the channels
before invoking the driver's remove callback.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code. The same omission was also reported by the
Sashiko bot while reviewing the Sahara relocation series.

Fixes: 7fb19ea1ec6a ("accel/qaic: Support the new READ_DATA implementation")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260701105055.8D4371F00A3A@smtp.kernel.org/
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
[jhugo: reorder cancel_work_sync() calls]
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917192512.56205-1-mhun512@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/sahara.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/qaic/sahara.c b/drivers/accel/qaic/sahara.c
index c7c0b3eb4b65f..6333c45ef7d2a 100644
--- a/drivers/accel/qaic/sahara.c
+++ b/drivers/accel/qaic/sahara.c
@@ -880,6 +880,7 @@ static void sahara_mhi_remove(struct mhi_device *mhi_dev)
 
 	cancel_work_sync(&context->fw_work);
 	cancel_work_sync(&context->dump_work);
+	cancel_work_sync(&context->read_data_work);
 	vfree(context->mem_dump);
 	sahara_release_image(context);
 	mhi_unprepare_from_transfer(mhi_dev);
-- 
2.53.0



