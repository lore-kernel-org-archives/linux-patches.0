Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707C21E0089;
	Tue,  8 Oct 2024 14:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728396390; cv=none; b=SzVd3vNiUWCH8pTAmuUf3hTQAb0K+iLJVOolWQVjnbQ2dK4ue1ly6UwWSNXlcCLLWgfReOIsf8+Jsxh0a9U+eE9whmdr7o9jlXd/qfdPMac+xhu1SukTm6J+Rz+nBpzuxqk9Ou9J8PhumZGgMfuA6mi7H1zsE0IOr0QMu84NYww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728396390; c=relaxed/simple;
	bh=pS5fIuaabBmymxUKBb/7k1VuQq0ijOjt0/DfNTRevEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O19ZzLgcva0EWNj2b0MQCJ8NUSQ4TKl/EzZ/TD2iMA0gH5n6zIBdWnH04fXmCuwEnwuCiypj39kSKUn1+Ji7bgdnqc0w2BvYzV7zdQf7MfVw5ueCymivWyTNREyllMpAPDM5fXrMw4Tuv5ll1vPxPyB1ltmPPaN7vD+/0ROuCMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7NloPUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7NloPUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0C7C4CEDE;
	Tue,  8 Oct 2024 14:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728396389;
	bh=pS5fIuaabBmymxUKBb/7k1VuQq0ijOjt0/DfNTRevEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H7NloPUUonbNDRMQ7zOxDZiEB0QJ9wg980/dLzIPmkln1oLoBqEudBLcCH4C7A/aY
	 miWdkFPBaDXG4k6nPl7oNcj6Q/52QaouqIGRiNBqFp7kX09DzXWQI17IGxhwbgMlnb
	 OlKePbefT5eYywTV8S7A/BHnPwNm4cv/qHZ0id2A=
Date: Tue, 8 Oct 2024 15:27:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>, Ingo Molnar <mingo@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 6.11 432/558] perf python: Disable
 -Wno-cast-function-type-mismatch if present on clang
Message-ID: <2024100859-enviable-phony-9be8@gregkh>
References: <20241008115702.214071228@linuxfoundation.org>
 <20241008115719.272201292@linuxfoundation.org>
 <CA+icZUUjDD6r1NMQ6Kiscq8Yt0a-vBYjh1SiW1oNMQEKPWXQbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUUjDD6r1NMQ6Kiscq8Yt0a-vBYjh1SiW1oNMQEKPWXQbA@mail.gmail.com>

On Tue, Oct 08, 2024 at 03:05:41PM +0200, Sedat Dilek wrote:
> On Tue, Oct 8, 2024 at 3:01 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.11-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > commit 00dc514612fe98cfa117193b9df28f15e7c9db9c upstream.
> >
> > The -Wcast-function-type-mismatch option was introduced in clang 19 and
> > its enabled by default, since we use -Werror, and python bindings do
> > casts that are valid but trips this warning, disable it if present.
> >
> > Closes: https://lore.kernel.org/all/CA+icZUXoJ6BS3GMhJHV3aZWyb5Cz2haFneX0C5pUMUUhG-UVKQ@mail.gmail.com
> > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Cc: Ian Rogers <irogers@google.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Nathan Chancellor <nathan@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: stable@vger.kernel.org # To allow building with the upcoming clang 19
> > Link: https://lore.kernel.org/lkml/CA+icZUVtHn8X1Tb_Y__c-WswsO0K8U9uy3r2MzKXwTA5THtL7w@mail.gmail.com
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  tools/perf/util/setup.py |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > --- a/tools/perf/util/setup.py
> > +++ b/tools/perf/util/setup.py
> > @@ -63,6 +63,8 @@ cflags = getenv('CFLAGS', '').split()
> >  cflags += ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter', '-Wno-redundant-decls' ]
> >  if cc_is_clang:
> >      cflags += ["-Wno-unused-command-line-argument" ]
> > +    if clang_has_option("-Wno-cast-function-type-mismatch"):
> > +        cflags += ["-Wno-cast-function-type-mismatch" ]
> >  else:
> >      cflags += ['-Wno-cast-function-type' ]
> >
> >
> >
> 
> ( I already responded to a stable-commits email sent to me, but here
> might be better. )
> 
> Hi Greg,
> 
> You need both patches:
> 
> upstream 00dc514612fe98cfa117193b9df28f15e7c9db9c
> "perf python: Disable -Wno-cast-function-type-mismatch if present on clang"
> ^^ You have only this one - sets only the warning flag
> 
> upstream b81162302001f41157f6e93654aaccc30e817e2a
> "perf python: Allow checking for the existence of warning"
> ^^ Add this please to all stable trees affected, Thanks.
> 
> Explanations in [1] and initial report in [2].

Thanks, now queued up!

greg k-h
