Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B451133F0
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 15:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC9DC34115;
	Fri, 15 Jul 2022 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1657897708;
	bh=kwiYIQ32sWvdOlyBWFEjp7c2i0+9WQzWZPgDQ5siYDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yd5v5jHYYFjiDgXrWTtDan0kJ3DliNwEXJ9GxbHa5w2qrT0wIqMmEtdHNheSAwwwo
	 RXz0VRRb3ZbsSuSktTTKOcePcOxCtstrwlfI5pcsyewi72zMyJIeLJTbkyESk39ydA
	 MdzEOHs3zRmmtUE3oBnVFH5ukBYjLpr3qzk/M7h0X9mBBeKS4xZkvEMzwPXwH1O/PY
	 uMIn8abCoFVocTjOIzvamuM33XeUgVuv9ADB49LfzEPLHV3+tELM3N1BwmuE4n0Htz
	 5VooE/KoVaZkHRwgIBwaz/ifT39UaxkNx5Q+PjCji9GKNHoE4zivKEu+HEREsOJB6W
	 TFYzE7dqicy6g==
Date: Fri, 15 Jul 2022 11:08:26 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH WIP v1 0/3] Fake series to test out b4 submit
Message-ID: <20220715150826.pvseeikmqqdxj2px@meerkat.local>
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>

On Thu, Jul 14, 2022 at 03:52:32PM -0400, Konstantin Ryabitsev wrote:
>This is a fake series that I created to test b4 submit. It will be sent
>to the patches list, but it's not a real set of patches. You can ignore
>everything about it.
>
>Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
>Suggested-by: Sockpuppet Squirrel <mricon@gmail.com>

This trailer was sent to the cover letter.

Acked-by: Lol Whoelse <mricon@kernel.org>

-K
