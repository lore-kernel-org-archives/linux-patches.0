Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9673A24C95
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OR103+WJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EB7C433C7;
	Tue, 10 Oct 2023 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696949697;
	bh=+dWa28SUL71+6q+6idT3MEKxjdPxnsJMhxPykvCZZio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OR103+WJ/uGhVTp2h4dwLDSw+Mu5Lomxu7bXBteZP0jbEMFruivcUGRawLomiWzn7
	 HZHreBS6PbnNvxyHOnx7K6sP55+rBRwViIun5mcP/ZUW0nBHpz/E3eO+34D2pA9OpX
	 jRqro4D1sgX2Qc4pOV/NbciPuqIVP91kBiZQR6/w=
Date: Tue, 10 Oct 2023 16:54:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?546L5b6B?= <zyytlz.wz@163.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 407/600] media: mtk-jpeg: Fix use after free bug due
 to uncanceled work
Message-ID: <2023101047-pumice-diligent-a08d@gregkh>
References: <20230911134633.619970489@linuxfoundation.org>
 <20230911134645.689607572@linuxfoundation.org>
 <5f19d638.6fa5.18b19f1d4fd.Coremail.zyytlz.wz@163.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f19d638.6fa5.18b19f1d4fd.Coremail.zyytlz.wz@163.com>

On Tue, Oct 10, 2023 at 10:16:01PM +0800, 王征 wrote:
> 
> Hi,
> 
> Sorry to bother you for I didn't know how to submit patch to a specific branch.
> Could you please push this patch to 5.10 branch? The chrome-os is affcted by this issue.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
