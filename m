Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044807;
	b=r5EMUQU3EpIv18gru98B/Z8AcUlUlgt0cfvUTTTo13WHyA6IvsU4vrqMJX8mqjbVAsFc
	 ApfpgdghSt6BJpOC4/08DFtgfjYOcZkLdblorTOK4ELPSlfFFnYis9LlgXpg1zTEjOrCB
	 pwl5+ohc3iH+JxB+qDRtCSy4XE3MPBkED4dlXmbSCtTA7Hh8EMPTgNn5lAGFYYlWzrsQE
	 8Fl5h6yeTdhsDtvlYrGU5iSyAi+HAAXuN+9fGf/G4JU2pnZyuYP7WtoWC6DJq6lyD3Q3O
	 rmOtawuSGyXx2WHZ+WGU+9GBFMxPCweURvO3UvNEsG/85oMcYff0AP+z3QC2Y/g7Iiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nvSATxnxpmG/faFkobFa+sgIxXpjEA/XY4GIIN1dHA8=;
	b=ygBUOT53R7y0vhCd2hxT+c+xsBHQVaXVduclOyuoq1p6MIP0irhWbtoMb+5UUuskaecd
	 fPvxTmWAOCyLCiT8RwprOnJe0i+jKXQpcO8pIkklE+WNZzS4I+ZPjjfcwkzav0HEQ3lKt
	 cjyQpCfV4EwVkYs2LDWnAFWN++vFTOt5QGHGO/n3CbkuthlJ4Ef2fE36lpoXor5yjs8Nw
	 IBJ9bgc00o6BLtQFm/5RcmcJ/1ESeV/cm/MftCHuDs5CHSm5q3wGJQEARHGCqnXrTZOpX
	 9uVy0NtAe8vJaztCH95ntl+iPrUwk6melZ1fOFDG+pDgBSpYZ6qCb4iAGBeWcWythzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmM5xeWf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD0860A2601;
	Wed, 18 Nov 2026 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmM5xeWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA3B1F000C9;
	Wed, 18 Nov 2026 23:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044807;
	bh=nvSATxnxpmG/faFkobFa+sgIxXpjEA/XY4GIIN1dHA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmM5xeWftpKvd+W4o7uq0jsqjT1ka7hVb44z1qMrSbGCVL0wIIhkXecmm+mY5a6sq
	 3tHGM3h6V3tPBNm/gBCqsV+8L1DniBkfAl4yZTX37FsU9EzE+HtqPV78ZQh4mFj8fa
	 Iit/3ZA/hYSSWwGSBwysacgCK49Z/i/PsFfwg+Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0699/2857] media: microchip-csi2dc: fix async notifier leak on probe error path
Date: Wed, 18 Nov 2026 15:28:53 +0100
Message-ID: <20261118150226.726617228@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit c7528789244ce7329ca883170fb9315d739ae985 ]

csi2dc_of_parse() ends up calling csi2dc_prepare_notifier(), which
registers the V4L2 async notifier with v4l2_async_nf_register(). The
probe error label csi2dc_probe_cleanup_notifier is reached after
csi2dc_of_parse() has already succeeded (e.g. when media entity init,
csi2dc_power() or v4l2_async_register_subdev() fail), but it calls only
v4l2_async_nf_cleanup() and never v4l2_async_nf_unregister().

The notifier therefore stays chained in the global notifier_list while
the enclosing struct csi2dc_device is freed, leading to list corruption
and a use-after-free when the list is next walked.

Unregister the notifier before cleaning it up on the error path,
matching the teardown already done in csi2dc_remove().

Fixes: 2de0b3c0f678 ("media: atmel: introduce microchip csi2dc driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/microchip-csi2dc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/atmel/microchip-csi2dc.c b/drivers/media/platform/atmel/microchip-csi2dc.c
index d5b359f607ae9..19d6cc5984445 100644
--- a/drivers/media/platform/atmel/microchip-csi2dc.c
+++ b/drivers/media/platform/atmel/microchip-csi2dc.c
@@ -734,6 +734,7 @@ static int csi2dc_probe(struct platform_device *pdev)
 	return 0;
 
 csi2dc_probe_cleanup_notifier:
+	v4l2_async_nf_unregister(&csi2dc->notifier);
 	v4l2_async_nf_cleanup(&csi2dc->notifier);
 csi2dc_probe_cleanup_entity:
 	media_entity_cleanup(&csi2dc->csi2dc_sd.entity);
-- 
2.53.0



