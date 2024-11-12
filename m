Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D47420F5AF;
	Tue, 12 Nov 2024 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408390; cv=none; b=bkOItQaQuC+Pe4JIFrXheBmFL5jEfRiwEa/aDfPaT0fOq49WDb7FNOLpCknmRIeXgzhLM2pSYc4jtkPJDPfs0MqpkGseWUJgXmkpzBTaA9La6tmqPi+17+SKtGJBpat/iX7EuSm/kmJa5zhNjefR5oQNLKxe5csKsR/tVLs2ddM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408390; c=relaxed/simple;
	bh=gLamf4uvQpjS10zu7d5vMLSYTpMeCIAb9CBuFbpyjnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emaMWdGuWYy2Z90xqWv8+zW5lb+948CxRrMVwkl4izfe5EQkgGdSQ0vVQJkNN5T9zZiK6+S1nQWMqC8JK/2c7jZI3vwsO/Qnzcwyar8BNSArKFASdE7QAv9deStsCNcAwWgo8caB3gr2rK76TS9EJoZ6AJSwBS0cD51t7rry8ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfA8JM0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfA8JM0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4A3C4CECD;
	Tue, 12 Nov 2024 10:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408390;
	bh=gLamf4uvQpjS10zu7d5vMLSYTpMeCIAb9CBuFbpyjnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfA8JM0Nt0dXwUCSugWuYlITBcNgRbhIOeH8/FDVj1FcfuAWTZ9xXHbjRaWNDdLEG
	 ybPy7PA3OB9EtHYszcfVoYcWy62T/n3LilwV3btCHqPVDm88xUSe2Kw7te1Vl17AJX
	 r09fZbvnt9nIO2Kvz8LoZhK83kT+GjYo/UtNjhbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.11 130/184] arm64: Kconfig: Make SME depend on BROKEN for now
Date: Tue, 12 Nov 2024 11:21:28 +0100
Message-ID: <20241112101905.854936497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 81235ae0c846e1fb46a2c6fe9283fe2b2b24f7dc upstream.

Although support for SME was merged in v5.19, we've since uncovered a
number of issues with the implementation, including issues which might
corrupt the FPSIMD/SVE/SME state of arbitrary tasks. While there are
patches to address some of these issues, ongoing review has highlighted
additional functional problems, and more time is necessary to analyse
and fix these.

For now, mark SME as BROKEN in the hope that we can fix things properly
in the near future. As SME is an OPTIONAL part of ARMv9.2+, and there is
very little extant hardware, this should not adversely affect the vast
majority of users.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org # 5.19
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20241106164220.2789279-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2173,6 +2173,7 @@ config ARM64_SME
 	bool "ARM Scalable Matrix Extension support"
 	default y
 	depends on ARM64_SVE
+	depends on BROKEN
 	help
 	  The Scalable Matrix Extension (SME) is an extension to the AArch64
 	  execution state which utilises a substantial subset of the SVE


