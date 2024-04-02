Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF4C3C478;
	Tue,  2 Apr 2024 07:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712044171; cv=none; b=kYGK8tkHbbCZ5U6J3ha0vTSYReINkXn6i/QzuBCFErPn1ImOc6zDRsCg8Z3zoLwEcQTTqaVevIHMgkV4DH+VkLk+lSf3mXtrK7onUvyg8xUK+3nxaTFcu9kvLiw6vMD/HxzPJCRvCOWwfPtGV0q1WVKDbXubRUGRc8hkGwHj8g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712044171; c=relaxed/simple;
	bh=KLXQqrRZr44NW2jVv076stuVYgAR6z84VbFy7SHhfQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nv8FYOGCcv9677C1G3S7YC1L8lxZAxkVHPfrCr3L/oZ87IOfbqt83xCF0IbJS/uDIq8ODrnogpjr06MDyQg/yfblwbhUnWftFBbVtPrSUegYJEd3zxasNYsBSAivcYqt8SucQbIAyc+j5QlizpimNvvCY8GKXOUuLJe03f0ovNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obA/CI7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obA/CI7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF4AC433F1;
	Tue,  2 Apr 2024 07:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712044170;
	bh=KLXQqrRZr44NW2jVv076stuVYgAR6z84VbFy7SHhfQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=obA/CI7JI4g4AoGmoSyd1HnvYJqVxLadnS8av7DukkEMwgzpGVuVjnvQtHktu4i+R
	 urf9E74eiHQMEPOiamSmxQGIo6Xl8HdU495ue6XL/QL0gdYn5BQ7yfKlPxVfy2Xiu/
	 VLMU1sg0wnQXipgkoFVseN3cCAtUlY0TL9Y0jPfk=
Date: Tue, 2 Apr 2024 09:49:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Collingbourne <pcc@google.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 6.7 267/432] serial: 8250_dw: Do not reclock if already
 at correct rate
Message-ID: <2024040217-tartar-curable-4894@gregkh>
References: <20240401152553.125349965@linuxfoundation.org>
 <20240401152601.112837269@linuxfoundation.org>
 <CAMn1gO6XMjbn7o63JiHyLrf_z0AFW69LZ_RcxG=1DWw9KttWGg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMn1gO6XMjbn7o63JiHyLrf_z0AFW69LZ_RcxG=1DWw9KttWGg@mail.gmail.com>

On Mon, Apr 01, 2024 at 10:16:30AM -0700, Peter Collingbourne wrote:
> On Mon, Apr 1, 2024 at 9:25 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.7-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi Greg,
> 
> This patch is being reverted for now, so it shouldn't go into any
> stable branches (I see that you sent similar messages for 6.6 and
> 6.1).

Thanks for reminding me, now dropped from all stable queues.

greg k-h
