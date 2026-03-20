Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01953BA24F;
	Fri, 20 Mar 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774017996; cv=none; b=aGLIsnUK/xNoImkXOovBw6zS75XTkrgbaEs5UBWPk4suKBta/LKytsk755uY08lt/JM0vsIhK4jcOUBqcqayFxGwawUScQs0s0RM3mkSwmn301Q8bm+9wQsRTZaoylPLoC3YUy7MPLpFS4ZjjOIsRp7YemQTHy0mNt4pk4sdXZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774017996; c=relaxed/simple;
	bh=HAj2cheHD7JQ4BRqS6pwR3rvbsK5zTArRXYGLLpkoNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6PZbn5i4RgisU5/u+5IQ3FUx0Ech7rltv4TbQutlPCFlcA/8j+yFKxr5U4EFUfbZOMU86gpqGbTQcv717bNYIUfQ3KMx8mvq6O+oBPH4JVpRpF6IZqTb7NzwdY3zLbWkmImsDtY9mS+MBE/hPPJcsR6bgaxwRxmhVxrGpk/s/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQu/SXlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQu/SXlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64237C4CEF7;
	Fri, 20 Mar 2026 14:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017996;
	bh=HAj2cheHD7JQ4BRqS6pwR3rvbsK5zTArRXYGLLpkoNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bQu/SXlKtrQ+XLgYupRXIiU7z/rKGNFA4Gj/Am48BXJykG2L2IaxkNx+vgAWWM7C5
	 tCweFj18Ec6rAm2SoSTAB/pMhTbQvliz73VSpxfvNCvWkt70yDwdXVnND7YC1a3vZM
	 FGd/YcOUwgDGaJlI72J0NJlNXOUNUqNH28M2SP5xbmwTnHaeeXKzgJxORl6dsZag96
	 wBV6xYi6MoorQ/Cos2z7Jw2Z3vPG5Fu6zwBvWWKtMHsicGsZ+3bSIczwgrMFNNGnfX
	 NyEwgXrc6AcXg9zr/R7j+WmcQ998CTapD/ol5DZQDgSWJJqt8N9dH61sYMypOebBG+
	 OcscDH9xxXxpw==
Date: Fri, 20 Mar 2026 07:46:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] init/initramfs.c: trivial fix: FSM -> Finite-state
 machine
Message-ID: <20260320144635.GA6202@frogsfrogsfrogs>
References: <20260319232721.452950-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319232721.452950-1-safinaskar@gmail.com>

On Thu, Mar 19, 2026 at 11:27:21PM +0000, Askar Safin wrote:
> FSM means "finite-state machine", but I think this is not obvious to
> everyone.
> 
> Signed-off-by: Askar Safin <safinaskar@gmail.com>
> ---
>  init/initramfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/initramfs.c b/init/initramfs.c
> index 139baed06..d29fe0a5c 100644
> --- a/init/initramfs.c
> +++ b/init/initramfs.c
> @@ -212,7 +212,7 @@ static void __init parse_header(char *s)
>  	hdr_csum = parsed[12];
>  }
>  
> -/* FSM */

...and here I thought all along that the initramfs code had been blessed
by the flying spaghetti monster! ;)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +/* Finite-state machine */
>  
>  static __initdata enum state {
>  	Start,
> 
> base-commit: a1d9d8e833781c44ab688708804ce35f20f3cbbd (mainline)
> -- 
> 2.47.3
> 
> 
