Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C018746424;
	Sat, 27 Apr 2024 14:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714226785; cv=none; b=YoXxwQGU0SKMGR1pWhbiTzmZu/pIYT4JxIFNwyjfdnX41k6KzzHUHaZ+vzyMHcW5IuF+aHFCjoPFHnA2Z56ykHc+tVqDFaulAk6E535IWBE9wFIUnnPQevsHNjwTMOlAldFkRF1LfvZiGELkLZK+oYF9JUd+g1FnSle+B23RXAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714226785; c=relaxed/simple;
	bh=hLrPxg3BLPiMJVc6MdY3Y/rYwQvFnoD4gdynSD6rah4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YxHq4iROPpdE58ZfjMKYdu/tkksZhhI8UmOPSrZuRg9hV3vyUlqt8LNVEqJl3Nh/b6UGejohkA7CTOXfP9u5jIwbf4ql33AVUDbEURStfPcI3LGuhRdWdUJPrKsStC9Es+tpWTcBvS4qjIdTKo4BcmIbpdKjiLQkB1PnnTJtN5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXIeGtkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXIeGtkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6C0C113CE;
	Sat, 27 Apr 2024 14:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714226785;
	bh=hLrPxg3BLPiMJVc6MdY3Y/rYwQvFnoD4gdynSD6rah4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IXIeGtklOllfN319s7poHlx+wuhEINjOrw34ckTgLjH7pRYrHkevKTL8n1mWLEvDW
	 d4hXdVgweuWp0KkG4J7VVjNMWsU9qVTR0MzWEUrWh6PA6ulOiJw/sxqUJIsnPVS178
	 XERr7/U4P7MZTOX2nWAmMleloJxTJrFIjqmkVw3Q=
Date: Sat, 27 Apr 2024 16:06:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rob Herring <robh@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 068/141] ARM: davinci: Drop unused includes
Message-ID: <2024042712--4d2e@gregkh>
References: <20240423213853.356988651@linuxfoundation.org>
 <20240423213855.436093838@linuxfoundation.org>
 <CAL_JsqJHa4j5p8V_wkWFf6G4Xem5P9X+2vK5p0DYbBShXLdM4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJHa4j5p8V_wkWFf6G4Xem5P9X+2vK5p0DYbBShXLdM4Q@mail.gmail.com>

On Thu, Apr 25, 2024 at 03:35:32PM -0500, Rob Herring wrote:
> On Tue, Apr 23, 2024 at 4:45 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> This doesn't seem like something needed for stable. Are the hundreds
> of other commits like this going too?

No, sorry, this isn't needed, now dropped.

greg k-h
