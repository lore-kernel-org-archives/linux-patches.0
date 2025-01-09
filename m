Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5C12EBEA;
	Thu,  9 Jan 2025 11:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736422535; cv=none; b=HJvScf5F1y2b7ynJP+bmy1ul+UQ1/nG79Y6loyuGH2ne/9/VqMyeUH5V3JhXm821jU1dGxugaZnTdh6SC2dMUplOQgTx2XvsBAXjIbO/HKwcOZDHDQ3hgva1P0gLRkBQZ+J9WtjsijsLWvFhQycIv4ebkRc8vPoLLA6fp839IXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736422535; c=relaxed/simple;
	bh=YM3jLEUkpeG+byOduX2QvF5va+ypdp9rwsy2pxR6Sz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7aMAJ807Hk2Xi6jxTOEMnpGi/9lcdMtPANKT6l60JZn8DiXDWVRglH8cKp9C86CXZ71UhYkTgANEmyzcEBRszlbqlzJVnqXz2fbCiAyzKtDUuS6Oh2TOpurQoeA6rpE/u9AztnheB4sRgX4ZWD2fDogDCZ11KwrefT8TgONBiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NX651Fmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NX651Fmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38866C4CED2;
	Thu,  9 Jan 2025 11:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736422534;
	bh=YM3jLEUkpeG+byOduX2QvF5va+ypdp9rwsy2pxR6Sz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NX651Fmgn29jgLQL7G1owHKmzmEjEGx2Dmc0hPfoJF9svgCeboQqqca+CTiXQlchS
	 eMIULDmXn8gFuC6psspAcPWYHanxkzUYERG3wjEZgxhPgDUgfNizxRfgBspu4CowoC
	 VxPmQo9ho/WZhZVk14gW7z4akNrvD7LS60hkPCAQ=
Date: Thu, 9 Jan 2025 12:35:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 017/222] rust: allow `clippy::needless_lifetimes`
Message-ID: <2025010925-privacy-attendee-17bb@gregkh>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151151.253706204@linuxfoundation.org>
 <CANiq72mdUv29ufH2iUc=PD3Lhqi9EJOc28yrsZRWbP2p2in42A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mdUv29ufH2iUc=PD3Lhqi9EJOc28yrsZRWbP2p2in42A@mail.gmail.com>

On Mon, Jan 06, 2025 at 08:41:37PM +0100, Miguel Ojeda wrote:
> On Mon, Jan 6, 2025 at 4:23 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> This should not be needed (because in 6.6.y the Rust version is
> pinned, unlike in 6.12.y), so both Rust-related commits can be
> dropped, but they should not hurt either (built-tested).
> 
> See https://lore.kernel.org/stable/CANiq72k9A-adJy8uzog_NdrrfLh6+EgHY0kqPcA5Y45Hod+OkQ@mail.gmail.com/

Now dropped, thanks!

greg k-h
