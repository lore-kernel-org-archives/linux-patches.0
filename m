Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98B3351C11
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 07:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338559; cv=none; b=Mc6hWEWrvRjscJpEyA95v6VKRsvmY+vZ3PcZN6G2c3WrGBpXBsWJnNTB2GgLApzve/T05tHFb1sMTdFNjRHTZTZMqxMgB7oM/XztOiqOaRlSgFDn1RhIFQOZjQTtTw9Y3+7NTUdM+NgmdvmBoQ6/gZl+hejE4xxhbV53URZd0FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338559; c=relaxed/simple;
	bh=jPMgjvRXZvw0m9JOtAFfqiUZcAlyMz8OFh08ADFh1Gc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dp7Cy3t7KbmlzVOQWJzl8MCP2OUWN5cj7JYifyZqWPP4poAo07XVm5BuHwX6nArh+bU28gBjqm+YMNkan0Wt8yXZLzB+LQ6/BXT5oOKotEKQQoWwOXQtLAJzFZO7JYgcRbmhvbNREebmBTCVbEBTlT89s7IIreavWSL+Hiu9zmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 216965F856;
	Tue, 24 Mar 2026 07:49:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id C71BE20011;
	Tue, 24 Mar 2026 07:48:59 +0000 (UTC)
Message-ID: <8356b144d7aa9475f41b5f5a46ff2bdc32837953.camel@perches.com>
Subject: Re: [PATCH] .get_maintainer.ignore: add myself
From: Joe Perches <joe@perches.com>
To: Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev
Date: Tue, 24 Mar 2026 00:48:57 -0700
In-Reply-To: <20260324054747.3171493-1-safinaskar@gmail.com>
References: <20260324054747.3171493-1-safinaskar@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Stat-Signature: iqt31f584cepm1znmmg87kwhc6893jyn
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: C71BE20011
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19OdH8IllDDW+cHOXfyKArnHfYQcOXsEY4=
X-HE-Tag: 1774338539-147485
X-HE-Meta: U2FsdGVkX1+fVt0/u7P5Ig1sUEr+uf0b1aGFAwLeNzYJKF9VTcWVh5djjdIGDlSAk2q8EXDKLidBM8VlRQO9o1HIyTYBFw5LLvLveCVOWuDR8oamt/tMXAkELeD7hbiQGT2Fpmr7QChniYZEvXYIT04MI2Z7yyW5587I2qbKDH4ms4rX7RTIU69CNekpCItnZlDSh+9sfCCCMGjhILBgrulEqru6Qv7roS2xUrz7cdPxIOiKr3rMFG+4ESST7wLHgIwi/ufg7p31LKxD9hAmo3/64B1R+GsnT9FIDztfycT6p1n3TGCbbzRHM7/nRxiVZmSM9WDCgQILJ8zhWgq1rDg/8RCWfSawzeeCzMys1WCIEj2zoFqGvcCZpblQOzfjJB/OjSQJXlRuucqWrPLcQN/mPYQLnr+bRIhQSTbu+kKjHY6xgJvXg+bdvopOmkOWHvhDWEc+HFJyYZYxLDkA4+rdxCc+N8wN3Exbf5yC0nhHMKEwuepVQ5n9aEe9QSZ5cw7Wc+9omc7MniBna7V8vELV/7yQD1SBiyMonR9vTJISrh6ARA2GeMiqsa7BfClI

On Tue, 2026-03-24 at 05:47 +0000, Askar Safin wrote:
> I don't want get_maintainer.pl to automatically print my email.
>=20
> Signed-off-by: Askar Safin <[safinaskar@gmail.com](mailto:safinaskar@gmai=
l.com)>
> ---
>=20
> Joe Perches, please, apply this.

I don't do that.
Send it to someone that will or pull it yourself.
Maybe GregKH or Andrew Morton.

Though I note that the only ones that get_maintainer actually
does this for the few commits that your email addresses signed
is for Documentation/admin-guide and that the zohomail.com
address is not shown.

> diff --git a/.get_maintainer.ignore b/.get_maintainer.ignore
[]
> @@ -1,6 +1,8 @@
>  Alan Cox <[alan@lxorguk.ukuu.org.uk](mailto:alan@lxorguk.ukuu.org.uk)>
>  Alan Cox <[root@hraefn.swansea.linux.org.uk](mailto:root@hraefn.swansea.=
linux.org.uk)>
>  Alyssa Rosenzweig <[alyssa@rosenzweig.io](mailto:alyssa@rosenzweig.io)>
> +Askar Safin <[safinaskar@gmail.com](mailto:safinaskar@gmail.com)>
> +Askar Safin <[safinaskar@zohomail.com](mailto:safinaskar@zohomail.com)>
>  Christoph Hellwig <[hch@lst.de](mailto:hch@lst.de)>
>  Jeff Kirsher <[jeffrey.t.kirsher@intel.com](mailto:jeffrey.t.kirsher@int=
el.com)>
>  Marc Gonzalez <[marc.w.gonzalez@free.fr](mailto:marc.w.gonzalez@free.fr)=
>
>=20
> base-commit: c369299895a591d96745d6492d4888259b004a9e (mainline)
>=20
> ```
