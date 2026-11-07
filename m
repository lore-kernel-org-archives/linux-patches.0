Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064270;
	b=riCJxBtuben8rYfRrTuPrrBPkThxRDvHCm1N2Oxx+5Qbpn4YirwBQShkyoJY+HmQqAqN
	 HENVXS9nLGWYvrNYJ/htA5Yf4FpKFAPF+rd3Z/Q52EajB9cmT1E/S8qJ8cCJPOsNn+qE0
	 eneuCQSz6drZzFBiNckQCwZLa93evEV/02T++i8mbw9bJ4svYaBO8MY1zGffBSlvfLXzy
	 Gs0YtmviYyztZyDT1Om6CKoTDG1q4H4a9IeakkXrml+bZTNV7uDXN8PV2jyRaynZel2K3
	 kbd/YGigdFkASXd3c3KNHDce70lsP4kxG1twM7NJdRkE2hDFQbquBYRfcI0ZRilVjhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tp0Fz3GZoS9wgshvj+Rz4YRO2uysEoRI0iXjNaurOM8=;
	b=Nj2ZVDygcX0MKF/+tliIJJdFL3l5rtc0VqSZ7shxnVI4MHlUTxHtrbtW7jPI0d58s6y6
	 CXAFeYxrD3smnlL6FVDWS/FDIwisvo90IBTDteSs88obTeG4J9ziAKHjSivrTz0fT1ZA7
	 W8WjQ12lh8EsJ6iFelf/JAirsOhTUoyb3t4WNT0e87xy0HTWlkdxYlhdStmILe7QILSR3
	 G2UQWINAGwnhsNV/uuMtxrPvVbc8gKj6pWF9dLi0FvvsBbLUdTqjV/rsSCR1XpK6/RfqJ
	 hwW/uqPQNogBsb3aKaMblb21kGbPxbMa0nDqrRIY+TiXW40d6/TYfwydZ0csPvYzKjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gTxQ/uyo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA72606A334;
	Sat,  7 Nov 2026 15:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTxQ/uyo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BD71F008A1;
	Sat,  7 Nov 2026 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064269;
	bh=Tp0Fz3GZoS9wgshvj+Rz4YRO2uysEoRI0iXjNaurOM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTxQ/uyozT+NLi88M/TwANggyaypd4QWsi7rbXMH6BDgHc7a0DlI0l1K6810DA9Gg
	 SIHfhb6YMuIeJOtoTq8imVDyTmCxTi7CMiioOs3HA5JLvgBg5LcHehq0i+Emx1gG7Y
	 kUJmzi5ikUW4sLjKu4EiqWxm4K0eEsCtS1RDo1gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0366/1257] media: iris: Fix bus_info prefix in VIDIOC_QUERYCAP
Date: Sat,  7 Nov 2026 08:44:22 -0500
Message-ID: <20261107134949.685807733@linuxfoundation.org>
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

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 1facae9bc3c1cfcabc77184754d64c349831cbc5 ]

The bus_info field returned by VIDIOC_QUERYCAP used the abbreviated
prefix "plat:" instead of the standard "platform:" prefix expected
for platform devices. v4l2-compliance validates that bus_info for
platform devices starts with "platform:", and fails otherwise:

fail: ../utils/v4l2-compliance/v4l2-compliance.cpp(671):
missing bus_info prefix ('plat:aa00000.video-codec:dec')

Update the format string in iris_querycap() to use "platform:" so
that v4l2-compliance bus_info check passes.

Fixes: 94ef75095d5e ("media: iris: Enumerate cap->bus_info to differentiate between encoder and decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vidc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vidc.c b/drivers/media/platform/qcom/iris/iris_vidc.c
index fcbc60016beec..d39ac71a25aa6 100644
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -466,7 +466,7 @@ static int iris_querycap(struct file *filp, void *fh, struct v4l2_capability *ca
 		info = "enc";
 	}
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
-		 "plat:%s:%s", dev_name(core->dev), info);
+		 "platform:%s:%s", dev_name(core->dev), info);
 
 	return 0;
 }
-- 
2.53.0



