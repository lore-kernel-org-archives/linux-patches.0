Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0054D36A009;
	Mon, 28 Sep 2026 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790592900; cv=none; b=KCLVlb2JV0Oxk+x9gzpufW3csPRJfEHKFNTEQPLUpv4dbt6KD4lNttYbgkLG5Q7k0Oj/lowSAoPF+5RinyOqLjOnBRyFGTVf1w07sq/L8DYrlAchkEDQHROYHPc8HNrcAfDAv0npBpSRb4apetm9j1qxLc+Fo3RQd3PYHop7JgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790592900; c=relaxed/simple;
	bh=RMiA1glm5nH84RTSkVfzcKxtvLXouWt4+7Y2p/BGxZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZxZvsKieNx9hXKbQZtkar8jyHb1/A9Bpchf7m4khQlkwYGRXgTsSEWEt76q1/LcA/aoUBJV+ccFRA546KwJOwIKr4RBsrcS8ugQn547j05EakLRIFxoHYHZXnpji/RKvv9n3XjiQ0iNisH7RKLPwE45Fifrl6zoNWPJ4Pcw+es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5Y2+Mc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5Y2+Mc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E080A1F000FF;
	Mon, 28 Sep 2026 10:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790592898;
	bh=vPvCVYSwaOmTKYCEYdt/i64f9mwJezF3NLnKoKYCTsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5Y2+Mc7Iqes0iqz8PcAu7pObpKxaQudzVAW79q/C8dZF8V5BXj2/e/xtyIp2bTOi
	 ciEMGcyL2W5sK95TNArp+W7vRRtegBIh7dhjBzIWl1whKmzUSQILATMjTtqsrt3+t+
	 qpyTNndR3ey+8SqkT9gNbfdUcSBL8AOtRxSI8UfFaKRfvRX9Ux1MkhR3ZP4RDtBfqI
	 0ndxzaNJOjszMRNM8JV1dag/P089vgl/58Id09dy7CZaPIrFUxwO0t3sQNauHA+JBH
	 0iY8guUyHd5F7ftTwFaPz2882CuYWcx7OveVvHd2DGHDSKWMrjYI6JEhiUe/CkCm0Z
	 /VPsU9pJsdlog==
From: Miguel Ojeda <ojeda@kernel.org>
To: ojeda@kernel.org
Cc: fujita.tomonori@gmail.com,
	gregkh@linuxfoundation.org,
	kuba@kernel.org,
	patches@lists.linux.dev,
	springbreeze@stu.pku.edu.cn,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit positions in device status accessors
Date: Mon, 28 Sep 2026 12:54:43 +0200
Message-ID: <20260928105443.205758-1-ojeda@kernel.org>
In-Reply-To: <20260928102547.201475-1-ojeda@kernel.org>
References: <20260928102547.201475-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 28 Sep 2026 12:25:47 +0200 Miguel Ojeda <ojeda@kernel.org> wrote:
>
> Let me send a quick series using a revert which is clearer, and if that
> is what you meant, then please confirm you are OK with the SoB!

Done:

  https://lore.kernel.org/stable/20260928104855.205416-1-ojeda@kernel.org/

I ended up sending #2 in the series with myself as author just in case,
but if you somehow had posted it elsewhere, or if you prefer to be
listed as author, please let us now!

Cheers,
Miguel
