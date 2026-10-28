Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221477;
	b=ae5/TTMiMFcsCoMee3PuoGxSVSMPw+1W7LS3wg6cep1gMYGoeplaDQff5teitgRhcsvm
	 VmunYy4I9HEp5QIl7k/Gm5i4gB5N4kXIMZ15vNUUPBovgUXNK+jqCPWgia0Ka5F+hafSG
	 eSG+tyrSm3IxwpAjnYMT50VhvpHE3wyi6dRqNAlks0HqpMqNlGiwlEuhP4YQopN6hMPtF
	 T3JSGWo3ZrjZul7B0efcAUIrUbIxNYSFOhdCG9Smgffd51b+fFg+NfI5jfAcGSSNAeL5Q
	 Z46kxDRTHuOYDx6Ir2aWPQRjHq+ydPlT/9bJwxtzWgNf6f1hBnleId9x5OyRgeilJyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xdQrfkFhosIRmS2TBqm8mdJ/rffuErfIkgzT+1USxTI=;
	b=PdamE/nPM1BBIOeHKWhz8/iW//0WJ+H6ZykfIz257T4mJXKEqejlaoTGBVwdxXOI781n
	 GMcwpoga9KFbet6OwFpTkgNbHTnXwYIrw+TAoieLSNxUrZF2x51as8jJflce+7uv6pm5E
	 PnBF/1qwkoSTe3qir16ArFsZqs/i52OSjNBQeYsGWSdm5s7VCxIfVLV3qusLAX4DWuFl5
	 17o+Fm6+YnxXWrKM+4casJkp9yBNqKQQOqIiJI6PmCaniZV6Uk8aBZeVsMgmqCu5db3LO
	 j2lM5Qn+myilmbHQ9KbyKLUoVWy8ofwmo4Xvx061XHfgwO/MyG5xLLULA5KdoBzESkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=abSLiHSC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A7C606A31E;
	Wed, 28 Oct 2026 21:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=abSLiHSC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AD61F031E0;
	Wed, 28 Oct 2026 21:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793221477;
	bh=xdQrfkFhosIRmS2TBqm8mdJ/rffuErfIkgzT+1USxTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abSLiHSCaHOXvXGxNHr9btOIwh2pPi6KL8O4aRKei9+CfVz5xYcpl/gSDAY1AqcH2
	 iYUJ13d3p+CdQuizpvNh6x8isL/gjYM4ai32h0X5E+04YX+1YZVR6OgkwCrzHI3HMF
	 lX4Fa70aaDs9DPO0Z1vqzf0yBBiJ97emHKJWIgqkeL2Wqy202CJTFvxJONtPirNk73
	 7USlqQ3qahMZ4K88eM8FzCxEKFuCSBQb+i1fEoH2u/RtQjvaa83+JvbO5SsVynVR7o
	 +EGgnNwDqM7C87oIiJf4K8LS36L/W4MwxPxk+2f5wR7JkmYjOGvizyqElxPMnztMKI
	 itxTUwfOF1Gbg==
From: Sasha Levin <sashal@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Sean Christopherson <seanjc@google.com>
Cc: patches@lists.linux.dev,
	stable@vger.kernel.org,
	Paul Durrant <paul@xen.org>,
	pbonzini@redhat.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.6] KVM: x86/xen: Prevent runstate times from becoming negative
Date: Wed, 28 Oct 2026 17:04:34 -0400
Message-ID: <20261028210434.2386138-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3bc2d742e0fa4944c5da6b4d2932225a1c1761d7.camel@infradead.org>
References: <20261019135441.1420968-1-sashal@kernel.org> <20261019135441.1420968-127-sashal@kernel.org> <atkdzsPJgcu123DO@google.com> <3bc2d742e0fa4944c5da6b4d2932225a1c1761d7.camel@infradead.org>
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

On Wed, Oct 21, 2026 at 10:01:53PM +0100, David Woodhouse wrote:
>Backporting this one to LTS kernels doesn't help anyone. The risk is
>low, but the benefit is lower.

Dropped, thanks.

-- 
Thanks,
Sasha
