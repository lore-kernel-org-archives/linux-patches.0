Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022694;
	b=yyxMMCAXDaLQIJIBJOqVL1YxqeV90vo9Iut+fExSyRDujSqPIZAUem3NiXw1wYV7ZVoU
	 h4655KVQUE12gMcvsGO6v+u9i4+AXC86AHs2Hnza6jkuREqRs91y358oXowmHL0IB1XSx
	 OpTnndrtmQdYpLjTaHzaJSIBnGs6vUSxo0xAV02owhe5phit6iGHkqYMl7CLA435Faila
	 q89OROoeZwf+RBAVQaIqhNw9j353L+WU5er1DzhgiImRN8plNEJSCO4iqM6xl226yVzHo
	 5S5OoioAw1lx6fXIWzijT7MImrZV0s7PzW4K+WFYcfzEXZ6vhdrvZW5PR5y72fdleMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YUifh0rX+3tJefOCQ7d1k9p4h9hzfwtgfkJndbxWyKM=;
	b=fcyLiT1cqHwjAepknKK/KfT6UnxQBaijGhVlBrH+Kjeng4JuNJJdRfchcf+srCL3s8xK
	 6VmOJvM7Pc3YDSN7RYavRwlP+/qY6Hn1Cl4xcxH0x0NyD4uZ0BLcskSsUaN0zFYvDkr8d
	 UwRY9oavRdLSVzRMVNfUr9LYPcob4gaGG3O4C9+YoWeYimKP9TqAUIE6tHzg4SXO6epFQ
	 t0H3e2bDTDcIRBDWZWQtehXy3CmFwO/E/Cjs9lTS6Nm5Jk6t35hIkVcE1X51NPnSqDn5w
	 k8xc4Kz4JAwMl/UYEN7qEzqW05reLP2USMF9XXfqNkN6vGdTTFGWbqKbj9BOZZ+EhSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X6J/MSFk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036E1606A325;
	Wed, 18 Nov 2026 17:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6J/MSFk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E65E1F000C4;
	Wed, 18 Nov 2026 17:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022693;
	bh=YUifh0rX+3tJefOCQ7d1k9p4h9hzfwtgfkJndbxWyKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6J/MSFkG1hiywa8niog/5jGNaozkYQGfzdlQ5JSFssnfS5b2lvxiltRlhFP5B17S
	 /XzZBe9xHD7R0wzh+DoBel1iz2lP+uU1hrRlHtG540KAHwxsMR2a5PjynKDJuo1MxE
	 uSIY3VINvHPWNw049pZz+7cvPg02nwwr86biN9kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0105/2151] ASoC: qcom: q6apm: clear g_apm on driver removal
Date: Wed, 18 Nov 2026 15:30:40 +0100
Message-ID: <20261118150125.624452927@linuxfoundation.org>
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

From: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>

[ Upstream commit be2172758f2b7c801ae80b9c8d1510b31eeffdaa ]

The global g_apm pointer is set during apm_probe() but never cleared
in apm_remove(). After the driver is removed the devm-managed struct
q6apm is freed, leaving g_apm dangling. A subsequent call to
q6apm_is_adsp_ready() dereferences the freed pointer.

Clear g_apm in apm_remove() before the component is unregistered so
that q6apm_is_adsp_ready() returns false instead of triggering a
use-after-free.

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Signed-off-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260923-vmid-v4-v6-1-3d61a0319b1c@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 7894d4430ff17..f12ae90c0a842 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -798,6 +798,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 static void apm_remove(gpr_device_t *gdev)
 {
+	g_apm = NULL;
 	of_platform_depopulate(&gdev->dev);
 	snd_soc_unregister_component(&gdev->dev);
 }
-- 
2.53.0



