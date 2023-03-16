Received: from sipsolutions.net (s3.sipsolutions.net [144.76.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD312563;
	Thu, 16 Mar 2023 08:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JwnXjalenYgwzyY4GkAtgH6oCJhNYPp0tAoIKqsKcQA=;
	t=1678955900; x=1680165500; b=wqauyFu6Wg7A5OyxTroZJmmua5dS1o5gtz1qYdEC5fHIaDr
	n7MLw4097L6/DM2LtXLspbGbtKaEtpeDGgicOor62s2eyDxJNOc2Qv1wubLpkYezIbVIwTMxeFLqh
	qzrGhg7zCcRVYCkKmsVc/YSChuYpj3MNkQd1vIUmRQxdl4MeIuk8otZ47yYdXseelbNugA5bXOtg7
	se3F5ocYCFq0hFhANfO+hBo9Gkt+X1+gRf+CTvDFsNNLJzKHdDOupDYnjwffVSQbQbQh6jo+pK+fL
	uZ7pV2D0BrlnEDSIGRhIs36UsvJvsjina0T34o8Gi2r0ck5kiIFRVzW83NOo0mFA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1pciPr-0053EN-23;
	Thu, 16 Mar 2023 08:52:52 +0100
Message-ID: <b9a4671bef0ad931a79c2911986286f1d9bb3ae9.camel@sipsolutions.net>
Subject: Re: [PATCH next] wifi: iwlwifi: Avoid disabling GCC specific flag
 with clang
From: Johannes Berg <johannes@sipsolutions.net>
To: Nathan Chancellor <nathan@kernel.org>, gregory.greenman@intel.com
Cc: kvalo@kernel.org, ndesaulniers@google.com, trix@redhat.com, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Date: Thu, 16 Mar 2023 08:52:50 +0100
In-Reply-To: <20230315-iwlwifi-fix-pragma-v1-1-ad23f92c4739@kernel.org>
References: <20230315-iwlwifi-fix-pragma-v1-1-ad23f92c4739@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2023-03-15 at 20:28 -0700, Nathan Chancellor wrote:
> Clang errors:
>=20
>   drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c:15:32: error: unknown=
 warning group '-Wsuggest-attribute=3Dformat', ignored [-Werror,-Wunknown-w=
arning-option]
>   #pragma GCC diagnostic ignored "-Wsuggest-attribute=3Dformat"
>                                  ^
>   1 error generated.

Oops.

> The warning being disabled by this pragma is GCC specific. Guard its use
> with CONFIG_CC_IS_GCC so that it is not used with clang to clear up the
> error.
>=20

Thanks.

johannes
