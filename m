Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2120C1C3F2B;
	Mon,  2 Sep 2024 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725274746; cv=none; b=lAvxlrdonVRFcMXLCF81gt8pIzPtTQsbxN/dk+KB+x5w+UTncTaOv4fhfJuU18KGRIU1g4OM7uiHxzO1usIlsAYO5okWQG4NuegX6IWQJRBmpusEW/n5JeGRAnzXvtT51SFK5y21z2eK8eFU2/wf6FaM9J4I3+WkWJdYW6cixo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725274746; c=relaxed/simple;
	bh=VkabMg1G/J3eCh7fJ13PJdYvPJYreYYZcHeUqILTJZs=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=h+ykQk5JTubod8L7iChLzkSJs5/A2n/pzSPLU+nL7RAipTRsCj7aosYZRAFy4Xt7ccv3MmJmQzFldyW/UJn8XTZzDFP480pIzWM2oVLcNURkFHmfo4xE5zqBUGOXaLTuNR3ji9P/NYmj7fml8tGvsXcK54X6PJ62GCO20lNmjW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=RqUIWWoR; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="RqUIWWoR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1725274690; x=1725879490; i=frank.scheiner@web.de;
	bh=VkabMg1G/J3eCh7fJ13PJdYvPJYreYYZcHeUqILTJZs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=RqUIWWoRIie0ugZPMHnBv3ao1ktoxSts+R8SYXesf8RXk3wzmNjawKU4IfZ7VEYG
	 dCh2WNhXMu8Nbq45gpE7vBSd6YaeW4Np9QdW7q9j2CFnrVgliiTS537SnQ9KKhV2C
	 YR9BmcNI6b1NvfZs8Ignk7dpbCtXT4ykOj3sWy/GonTXv5n9/lx2Vu2ZBeuWvTsUQ
	 3FSxluGHNkOwZ3msg5T6J3e6z+q0+jHJYcOJLHcUivPYfFWti6a+Avu5x2Q3X9ViG
	 3fcLEhuRP/R2xLjezeQqwrTEg4LDOdPTiJKnPWeMLkhlwirh6md6BOv4qRkLTdhW/
	 e4s2y9niomfjkzz22Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([84.152.250.180]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mi537-1s73BL2NPt-00b8LH; Mon, 02
 Sep 2024 12:58:10 +0200
Message-ID: <ca1d2ed3-6328-47ca-874a-5b18a010a85a@web.de>
Date: Mon, 2 Sep 2024 12:58:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: gregkh@linuxfoundation.org
Cc: a.hindborg@samsung.com, akpm@linux-foundation.org, alex.gaynor@gmail.com,
 aliceryhl@google.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
 boqun.feng@gmail.com, cl@linux.com, dennis@kernel.org, gary@garyguo.net,
 keescook@chromium.org, kent.overstreet@linux.dev, nathan@kernel.org,
 ojeda@kernel.org, pasha.tatashin@soleen.com, patches@lists.linux.dev,
 peterz@infradead.org, sashal@kernel.org, stable@vger.kernel.org,
 surenb@google.com, tj@kernel.org, vbabka@suse.cz, viro@zeniv.linux.org.uk,
 wedsonaf@gmail.com
References: <20240901160808.908613948@linuxfoundation.org>
Subject: Re: [PATCH 6.6 41/93] Revert "change alloc_pages name in dma_map_ops
 to avoid name conflicts"
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20240901160808.908613948@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lKRwo+1QlPoEqVRWAFv1FkPLl55849RbCkVsabVcxsySoziG4GD
 Nr5agLYyU5iP+jo7A4Mz3RBEyR1GKo6OtkAiXiRfSD5xZ5qYlg+kSayUrQzJWWEEmVGyu53
 fHXatoWHH7Bf9luyQDYPIAof/06h+nRTRrZa1n8qdOplAEnLMiDeuUBWNgZA5ac4rgFB20/
 RRFdnvtkUEzbtgxik/FTg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nua4ASzHzZk=;fOr7lO0ylLhqwGWMT4f2LdTCtbj
 kN90jczra8CM+F4LH0m1gvtosFNpEGhIDS8+nrVwMAjunP2RyAheFW8uFiXVKEyTqhxkaTs5l
 cVj8PjSlOWMJfqDE5Rxq7bUPzCOYeKrXWN5xfVTnrDDh1hUCvNknnNyZX6HGMe5VA+w05scSB
 bgzPTSKopoOH/oQksvPyXjPblqJPSnCSzoGQDXJ4yDM4RNtXrTE4jCzjCKwUAE9r1Zie/3R9+
 mP2FnvG1jJBIjSj0oRvJML15kEcZvnM0Yajd6VUOkO8T0tWjxkKlX2+7Nz2G3smlbChaW84SH
 q/70+zoMCEmklvdez9Kfnhe66o0rqKtMU7edYMI9LZwSnJ3QoKKJ3CDjCVEUIXGnilSsvxF21
 VSHPj5A/LcM31T3Gz28RlpvTZ9E2xQ8Uv7eGam+5o9UX4UEa78LCMzb/OxIZyb9Kl1AX8ZNsL
 vn6gLjjAKrfqfyVA7UQLo0aNjjxXHBbavKlOFxPu78rqqzEofzuoZXlgpmz+ex8gUt516/zoo
 e1cYGm5QN/3FxIrmieOxVMEE/7DkdKv3fPFUq1qWcbzu1aIH5xqN+0OBsvm/GXdrCXq7GKMTT
 fd4MCC+60ItWiDeNd+SBa4hN2JHuyygzNMgRuFRjWbInjXEke4Hi5haIg6NPZ46k84zLdBQs2
 pkNuKxGjWA3KMI3y/T2N3CR8Ki6OBUfcoyyugnsrRjq4rwZmn6o+iCpAjrnJjNL5P3WwbMR8k
 TS1GT+T8FSg/dajgEuX5uwNApUgdxenkXwwSyJVDchq4chQmb9LvvkRJ8piZo82tYHQuCYGxv
 7Aj/42D532U88HQwzhMQVUrHjf3Yb8OAX+8Fbq8Sxbh78=

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This reverts commit 983e6b2636f0099dbac1874c9e885bbe1cf2df05 which is
> commit 8a2f11878771da65b8ac135c73b47dae13afbd62 upstream.
>
> It wasn't needed and caused a build break on s390, so just revert it
> entirely.

Thanks for reverting this, as it also broke the build for ia64 since
6.6.48-rc1 (see e.g. [1]).

[1]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/10589507221/job=
/29344063186#step:8:1892

Cheers,
Frank
