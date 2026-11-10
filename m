Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794344400;
	b=Iu9x++1bqYB29mAb6qMSFXw72Y0aNewZ0j8hRD2Dhn/BHjKnmD7PD+2BSbZ8zRqvJ7rb
	 AYJ6k7+XEYc9adMmEraThCO7VQZpAFXaUyhIF9q25wYBVD1Am128wLSzYC4ZU59+pSLWZ
	 h6Qg1bltN1CIef9dusIa0XIqoB+U5VbQCn285FsxKpBhHSLfkKsaVKyLWfn6zRXo2c+Nz
	 NUn7/Hl6d9/tZothO1hUCIjJHuOzKsw5WQe//CGVMypBYug19Xu+rZsIKxODQIZqLPMJk
	 XqRGdF1s7HeMHwz5RECv3pCWD8q2HIw1e4qHIy9neQrWjykxWdKE1KmhW7ai0IVnOGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794344400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=S/FeE+RC3DzmhiiSy3tAczDptJXTBkeu9oA2OuyOpIM=;
	b=IPab0MADyO4bha9hWoikILWj9aT9Rjc1mePY0JZ4Csa1iImzvYG30hsHYNjKya2AQ0Nw
	 7TjYgZOfZ/9xgtCwvv6KUxwi9JZcZKzEyw2wc3n2YGG8lEFhKo6B5ADiiuYa2tTgFnMLf
	 Vzi+vf36A8FkW3hLD00pfAa2BBciF+Xga34kbuJdIVkwtEaY/vtMmrpHSHqq3kydXuQnN
	 ZfmvSy8IhNGmrlokQYoKd9fQ2QsVaxTWtcryu8DxyZF5uUNCHnCNPE50U8QenYLFkSx4i
	 jqjuujue/5PIVZqL2SSmuxdjn1H9CtDSziByemrxLNvkHMfH2R6xOeRXR5xBATbClPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zz69psnD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927AD606A32E;
	Tue, 10 Nov 2026 21:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zz69psnD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8037D1F008A1;
	Tue, 10 Nov 2026 20:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344400;
	bh=S/FeE+RC3DzmhiiSy3tAczDptJXTBkeu9oA2OuyOpIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zz69psnDyoNEEep/IIPTPO3nm/3MiE7qpYfXKD1yzl1Ow9Slp8S/8WuCXpr0ImfoY
	 NiKqYpjGejyRiBDwKEmfRZ1ZzTEEC91J4wAKAAKdGaS051VAcGTcJ23vJj097yBcov
	 XI3ILLsfxBpN1Nw4BeKL0kPf3otzE75cm5eipl7Wlxj2rzjOsSsdNg4uHicYLDLSwE
	 pS4+8NJPPXyksEvfqWyW9HDjPvWNlkywMGEgVknH0a69Va7bOSt53ZXSTFu85i3qW0
	 2ugdgeTKhd+5vVe2u45TPPJKf8BtyfuhN1prRSs5Gpi4zrbk5CVSADo2big55tpYww
	 bQDZ5XcE8wPTg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Paschalis.Mpeis@arm.com,
	aaupov@meta.com,
	acme@redhat.com,
	corbet@lwn.net,
	irogers@google.com,
	james.clark@linaro.org,
	jolsa@kernel.org,
	leo.yan@arm.com,
	linux-doc@vger.kernel.org,
	mike.leach@arm.com,
	namhyung@kernel.org,
	patches@lists.linux.dev,
	robert.walker@arm.com,
	skhan@linuxfoundation.org,
	suzuki.poulose@arm.com,
	amelie.delaunay@foss.st.com,
	valentin.caron@foss.st.com
Subject: Re: [PATCH 6.6.y] perf cs-etm: fix a compilation issue in cs_etm_decoder__set_tid()
Date: Tue, 10 Nov 2026 15:59:24 -0500
Message-ID: <2026-11-10-1-daily-reply-0028-perf-cs-etm-6.6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261109171457.1233670-1-valentin.caron@foss.st.com>
References: <20261109171457.1233670-1-valentin.caron@foss.st.com>
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

> perf cs-etm: fix a compilation issue in cs_etm_decoder__set_tid()

Queued for 6.6, thanks.

-- 
Thanks,
Sasha
