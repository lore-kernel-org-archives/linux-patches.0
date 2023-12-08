Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415D41C290;
	Fri,  8 Dec 2023 13:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fjasle.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b="eCbJM65F"
Received: from leknes.fjasle.eu ([46.142.121.132]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MDhth-1r36rE2vLz-00ApQE; Fri, 08 Dec 2023 14:20:51 +0100
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
	id 1E47A3E78A; Fri,  8 Dec 2023 14:20:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
	t=1702041641; bh=QDL5JcqlyVOnFIyl+IQV8GsQ4nRlAMjLx+obmLW8jTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eCbJM65FZFkCfv6CHsYJNVM4KDXDSop7vJNSjw6UjR7M6KrQJ0M/73HlPC0kTl9Pb
	 g0+QRbL3RajyHgWiF/4KZbeD6bZER9TWL8eQI4egrxCD0yQejtsj3+avIv89au+cDn
	 TY3a7Hgu0tCOLu072tP4QuH5+loOWKrudPT+iZTg=
Date: Fri, 8 Dec 2023 14:20:39 +0100
From: Nicolas Schier <nicolas@fjasle.eu>
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, ndesaulniers@google.com, morbo@google.com,
	justinstitt@google.com, linux-kbuild@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: Add scripts/clang-tools to Kbuild section
Message-ID: <ZXMYJ6JCm3ZmDJ9G@fjasle.eu>
References: <20231205-maintainers-kbuild-clang-tools-v1-1-a646a1985300@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205-maintainers-kbuild-clang-tools-v1-1-a646a1985300@kernel.org>
X-Provags-ID: V03:K1:iYfwVXTmwwrYz1qs3mVONKhDPEE1wQY7wYRTotUVhsZaDlv7/+f
 iPJhP7egDSBrXu/RZsJYEWNt3G3aAEJVTWkONFs5juLZPZ6VVUBd4jBSoJQwyVn7ZMv8OxI
 uEx+mlafCrUR/d93pgxyX7ginLOlHlDeg/U3WbK/qBS1l3hvC1vZI0XAwv0iaIBH6txcA91
 g5ogTfQn7ipaaik0hxjhg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:R5mxsVcB3sw=;HD28HwgfVKeRCezuPbxE/qWu1An
 ljTj6BxNYyfXLSFi7G2Skiw0cyBUTZTo16E37WNEZxzG4AhbEjTHiLDDFN12MqGivTi9ikKS+
 zxTMxrckfiBEbkZVlk8jDdeaQZEw4WjRGxKZDqlj0rthKdVn0n0eBPi3LvXQ12VuYZQP7gEYU
 kdGqxFcSYyaSu4FASwC0cMakIMLDw0DDyU8ZQDhGg1NM4jBwvW24K/LsIF2NjIx2jryomGoA2
 f4isFyepw3zpIpInraIu9aBdKvU+ikqIawBsUK8d2EGkc88lIxn6WtAsLgMiQD0HCOAezOEYI
 DrM7HzvGrfaLEP64lLUGXD6tfx8VpZYJ61Hy3EONn5/Nv6QarbdbLu+Yk8EAo9PytoKnnXoQI
 SKuYiW5+I23oliSEzcma21p0Zfiq46SOQeHDGbFMiANRFz9XebAkfiVpmh4lfJoEeFjKXLwA9
 e0Xnr1likfBMJraSxeVs4YqDxj6R54QEfYWE+PP1hYeaO3YopnEXXt7snupatRdJn7cYIZ/Tr
 9lPHOg/fEOtrhkirGA9Zug/ysTr8c3cThstxoFxf+eHkfGxWn36c8yym1U4T04Q6exJFBsKtA
 /GReP2hz07tYKIQVRs/VPUremMeNi8yMFKgE/SoqF1xw/KUPDYrqHl9AwcND9RAV716MCOK7D
 l7157RW5BHUOgxmBnqoGog0VxnSzhhlvSm9MyvwSLLKSWi5zZt5XHLHn9PFmtyftjoIfDfKQP
 Teuk/lrp25UUo5+tBznHlbXWVAAAWwpVKG2HFJzPmuW2sNiY59wqFGgJc/xn4Sx/FtCe67Npy
 uwO7ex3YnOGMz0jm0OKcBh6Sq337zvxZrg4GaGFo48DNBXL4ro+XkaakN7VZtxhJqn2/CHULT
 Aiv0Fzc3etlNRbQ==

On Tue, Dec 05, 2023 at 10:05:57AM -0700 Nathan Chancellor wrote:
> Masahiro has always applied scripts/clang-tools patches but it is not
> included in the Kbuild section, so neither he nor linux-kbuild get cc'd
> on patches that touch those files.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 788be9ab5b73..cd9bf44dc1b3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11526,6 +11526,7 @@ F:	scripts/*vmlinux*
>  F:	scripts/Kbuild*
>  F:	scripts/Makefile*
>  F:	scripts/basic/
> +F:	scripts/clang-tools/
>  F:	scripts/dummy-tools/
>  F:	scripts/mk*
>  F:	scripts/mod/
> 
> ---
> base-commit: 33cc938e65a98f1d29d0a18403dbbee050dcad9a
> change-id: 20231205-maintainers-kbuild-clang-tools-93666b423b02
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>

Thanks, sounds reasonable to me.

Acked-by: Nicolas Schier <nicolas@fjasle.eu>
