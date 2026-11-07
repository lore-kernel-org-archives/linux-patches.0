Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794091098;
	b=1e+8IBnyquePJxPyY1Patkg2ijkkHub3rKLH1pidMMtnOsmeC0zxpDcNpMv3OKwTOoWm
	 x2NX96NmvOL0SSxTs3Gwler5ThsHkNOAQ7OhA4aET+GpH59IZySkBK4sVDX1Wmlr+mO0e
	 lSPMhr3Fm4nQlGqOopnuLZ9Oa26xL5dvxthPlYo65eSJ8JJQxOTImm0WS7sV3gny4MTdu
	 PZo2OXVhwS0gJ73NHc0EZDBti17OzNlIE+qdhMWnBGzcRxK8OmOpZm9D0BdOCHpbmAC7w
	 ES2Fm5YpN31HmWMQDZ4Ifd6B7N3eokIQB3xkhyjhLI2ads5i5scPRJpZKZdpwNRE2Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794091098;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LTsAVe7V0nL/Wxk//NqKgJ3Wt7Pv5zbdU+ocORt2kGI=;
	b=OImsJrlImuvOCFTXw9qOWW4o7nctSSFBNYEZkbzCX0obq952yXERkKgYSkLRBLqLxYxT
	 HkbMk+r2p+3i26mU1yzYa5k/9Su3zSbgn/MXHqd6XZJuvKzHstsyMlNe72jtLfw6QaJak
	 z6qU9pi9Yr+R6vJEMgjaYjreUcP2VHTBa3aHLIDKKLkp4KR6sOZ/pF6soYP0J4E5kL3hM
	 zUsKgc9tf1XvRNr1DEqFTKB6D7XLUGacyCOS3qbwuKBIYkciz/cQMF+Jl1/VwHtQi8/ec
	 +OyOJ2Vl/WItHvZWkKrM6tL1Ib7NZdlVgIN/ng3ydR0qpAX8v5Ad78nCBciPwrQiISw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="j6V/DbGA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E49F606A326;
	Sat,  7 Nov 2026 22:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6V/DbGA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA7E1F0089F;
	Sat,  7 Nov 2026 22:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794091097;
	bh=LTsAVe7V0nL/Wxk//NqKgJ3Wt7Pv5zbdU+ocORt2kGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j6V/DbGA7pbh758tbM60REv+1sRCusoHIFODIiVuyjMicfGxy7Xjyd/zkJ3kWIhce
	 GhYE+43hWmeIRwEdDNbw07UM0w+FbtJI5aCDsZNv1cam7vuFKsqC+UwIoYW8/MIzyU
	 AdDWxmot1TI9yJTabHh35KyMMyYhaQ6O4w2ZcxiwpJuY92VIVtsYkwc43nt4AusHr8
	 X1WwA0GkU8O1U+MPLu989yjM3lm0ylLwfBq7DTMfYeXV5UEmoIRCYI0F/J5zOwd/av
	 Hp3013CUHVLpeMpUHhqL0dKWZU0QmqeP86GxKa5qcQeOydbGgF0/iWLJOXZBJSudes
	 G8myPdHcd53mA==
Date: Sat, 7 Nov 2026 14:38:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alberto Garcia <berto@igalia.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 1103/1257] ext4: reject encrypted inodes when block
 size > page size
Message-ID: <20261107223816.GA190954@quark>
References: <20261107134939.434104957@linuxfoundation.org>
 <20261107135009.727232083@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107135009.727232083@linuxfoundation.org>

On Sat, Nov 07, 2026 at 08:56:39AM -0500, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alberto Garcia <berto@igalia.com>
> 
> [ Upstream commit a5e894bc87b76fd980075892ba77e6bdeeb5e4d0 ]
> 
> Encryption is not supported when a filesystem's block size is larger
> than the page size. ext4_check_large_folio() refuses to mount a
> filesystem like that if the "encrypt" feature is already enabled, and
> ext4_set_context() refuses to create encrypted inodes if the feature
> is enabled after mounting.
> 
> However, a corrupted or hand-crafted filesystem can still have
> encrypted inodes even if the "encrypt" feature is not set, and those
> inodes can be unlocked if they're using v1 policies.
> 
> Check this in __ext4_iget() and reject them as corrupted.
> 
> Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities when BS > PS")
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Cc: stable@vger.kernel.org # v6.19+
> Signed-off-by: Alberto Garcia <berto@igalia.com>
> Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> Link: https://patch.msgid.link/aeb8efa8beb72721fb4b13cffe6eb22c795ec33f.1790343958.git.berto@igalia.com
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ext4/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index fb0548b3355c5..6697c33d3aa33 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5671,6 +5671,12 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
>  		ret = -EFSCORRUPTED;
>  		goto bad_inode;
>  	}
> +	if (IS_ENCRYPTED(inode) && sb->s_blocksize > PAGE_SIZE) {
> +		ext4_error_inode(inode, function, line, 0,
> +				 "encrypted inode with block size larger than page size");
> +		ret = -EFSCORRUPTED;
> +		goto bad_inode;
> +	}
>  
>  	ext4_set_inode_mapping_order(inode);

This particular patch should be fine, but I have a question about
whether it's guaranteed that the diffs in these stable-review emails
will match the ones that actually get released.

As we know
(https://lore.kernel.org/linux-crypto/20261021164836.GB1879@quark/), the
cherry-pick process used by the stable maintainers doesn't actually use
'git cherry-pick' as expected, but rather formats the upstream patch as
a patch file with 3 lines of context, then applies it with a fuzz of 2.
That means only 1 line of context has to match for the patch to apply.

For this patch, those context lines are just a closing brace and an
empty line.  Those are very common!  So there are actually quite a few
other places in the file that the patch could have been applied to; it
seems the only thing that saves us in most cases is chance and the line
numbers not having shifted too much.

So my question is this: let's suppose the upstream commit did get
applied to the wrong place in the file that happened to share the same 1
line of context.  Of course, this email is being sent out with the
standard 3 lines of context.  Is this email the original patch file that
was applied (and thus the context doesn't necessarily match the context
in the commit that actually gets released), or is a new patch file
generated after application and that is what is sent out for review?

- Eric
