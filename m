Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019699;
	b=P/C6xIq/dzWzWeXiimN0E+ZLC+mHfq+qRssgYd6t/G5L40WE1maEsk6UaUwCso2GfDEP
	 c5wO8sAqKuAYe98//RgBsRXSvibTxYvtBFs1HHvh7YL2T/NZKfr6O3kd4rZQy98T/aEJk
	 v8FLQAXC6xLw4FqnubBMic0Q/cmJ+Ug83mzmRADbWGFU2Lv/tFuGlvqzMWvXJRPm5crRS
	 0KEgRlrWRC0Fej3F+5G3kO83Iwzy+pZV6BzRbHR9wQE1mWBMIoBS7ImdayHf7NNciJmVH
	 vyQvHRG8Ly6jm7JJOq+CCZj3K+pZNGw4BVQKyqeJChN3J+pw+PzrqydWVbVAbli9t6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/kl700NnKvc22U5qutNPHIZCT/LBPc97+fI/O3Fd1uI=;
	b=ukpirj88e+24wkBE1G+r2L7QA6EiyLyEeNJYaVUdN+sWo0OuPZ7s+r3dYfKTcX8jvQAn
	 UIHC+rvfpKa7ZGxyzBnDa+Qg2MkLQ4/fc7qV91lDm92J9aXzLJnUUB3xDzeQn/vPLsxvM
	 4vDLpLoVz5uGegZ4qpqL9AdXfovp1bAgzd/RML4xiZZHwiqZAgXqBH37DdBrUHU7PGI5P
	 zJF1bi6ut0md+eGB8bapph+3GXh7W/b3zD3fPeV1NpLkV2lRO/ykxlgVL7ykbTKsGxDjy
	 /HeyDmsztJzxqTUGGQo1nmTLB14ZR97unr6+36WQFcpNdrJRw2OgsVgwAarup5Tf2RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oxavsQ/V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F2C606A331;
	Wed, 18 Nov 2026 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxavsQ/V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297571F000C4;
	Wed, 18 Nov 2026 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019699;
	bh=/kl700NnKvc22U5qutNPHIZCT/LBPc97+fI/O3Fd1uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxavsQ/V6AN0yQR3CCF0zfaXpJ1tZ1kC4nMJGNhnZlMfEHcpOGXutR526g9m69CBO
	 oU2PbzJbxqGWuh+dHiG4BNugY32ycIBAUb7S7p/ygWvd7JrL3KVm8HdFvJ+iLddgwY
	 PufUfB+SxrV1JP8MU+flhagniSSTqS2jzw59DABk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daasaradhi Mannava <daasaradhimannava@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1688/2651] platform/x86: msi-ec: Report valid charge thresholds when unset
Date: Wed, 18 Nov 2026 15:48:48 +0100
Message-ID: <20261118150348.447131467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daasaradhi Mannava <daasaradhimannava@gmail.com>

[ Upstream commit a102207eaf4a18c60c2ffbdc421ad3d30bfed591 ]

The charge thresholds are computed by subtracting a fixed offset from
the raw EC value. When no charge limit has been set, the EC can hold a
value below range_min (0x80 on an MSI GL65 Leopard 9SCXK), and reading
the sysfs attributes returns nonsense:

  charge_control_start_threshold: -10
  charge_control_end_threshold:   0

Both attributes are documented to be within 0 - 100, and an end
threshold of 0 wrongly suggests that charging is disabled.

The store path already rejects values outside range_min..range_max.
Apply the same range to the show path and report the maximum threshold
for any value outside of it.

Tested on an MSI GL65 Leopard 9SCXK (EC firmware 16U8EMS2.100) with
the EC holding 0x80: the attributes now read 90 and 100.

Fixes: 392cacf2aa10 ("platform/x86: Add new msi-ec driver")
Assisted-by: LLM
Signed-off-by: Daasaradhi Mannava <daasaradhimannava@gmail.com>
Link: https://patch.msgid.link/20260916174812.11496-1-daasaradhimannava@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-ec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index 566dfc73cb67e..1762551e072ad 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -1279,6 +1279,15 @@ static ssize_t charge_control_threshold_show(u8 offset,
 	if (result < 0)
 		return result;
 
+	/*
+	 * The EC may hold an out-of-range value (e.g. 0x80) when no charge
+	 * limit has been set. Report the maximum threshold instead of a
+	 * meaningless (possibly negative) percentage.
+	 */
+	if (rdata < conf.charge_control.range_min ||
+	    rdata > conf.charge_control.range_max)
+		rdata = conf.charge_control.range_max;
+
 	return sysfs_emit(buf, "%i\n", rdata - offset);
 }
 
-- 
2.53.0



