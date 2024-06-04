Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238C13E8BF
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 20:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717532373; cv=none; b=M4+8Ck5syhW5JjxZo0MD/dMmyokvLD5Ez+flHECTFJWm2OB2DHPAMP1KD/NNEbb+8jhaH5OBqfuby5f8yzCiYvQuE2HryP3DwnTBi1FmvQlLg/fC5Ryn+bKm97W24R85M7e52Et1HdCDnR7o40CetaQf6anbxagPtoepTxXZd0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717532373; c=relaxed/simple;
	bh=xfed6Cfrm4TYAkaOK6QS9lthrhaOfXoUEarZpKNCE3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O86/Wz19ukwpeu55oPnYZjjMcfwAhONTxD/b1vIvHyga+9YvbLMdhIsMW1NwnEB47wLfsxkp1qw4pU6pHk158OYhgKAyulkD/rfDQernhPWhh2JdMq4ta9skSQxtggG3QtBqMZt4FTUy7b7PwLUbtrKVUFBecfeTEOt0N8MysLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rG/dc3M1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rG/dc3M1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9761C4AF0A
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 20:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717532372;
	bh=xfed6Cfrm4TYAkaOK6QS9lthrhaOfXoUEarZpKNCE3o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rG/dc3M1CG5owOIa1XY6ze4o7kfMnD+PsTfmDwTVwgwG9ydgIW+oS5cJAsUNTIpD0
	 RN+NGNQnSwiE5VCW+UQLk08bqTGnghi4AeIOF8Q0b8M+7mp8FvyyfqQOo8YIPKMhOY
	 p6dd/ECrPIqdLrjz1WedwmuDPjsIrLrOlco6IOWGzpTl0IFeJqJmGTfIigRkL/tmTJ
	 2InR+eOV2BGWjOEHMD/Fgb+9qI0RdNYz/1a6I8hTVdrAWsb3MfbLqrn13bBBg86w/U
	 P7z70Xzz4dLq/xsowpHr6jQ/PgIp1XqPdmDZRVUGcQb02/1sH8KIk9jXYAWAdchRy5
	 gBMhcNXprTCXQ==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52961b77655so1563922e87.2
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 13:19:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUUuqnO5LIATreRXjCx2kVjaxdrG2NtgqTnQnTQ+lSetCV5ekTyJ3dI+pUiz9iDL4XFnC7lFhSxm+Nr37dNywO+LTGNZXiVwQ==
X-Gm-Message-State: AOJu0YzkMow1k1FaGM6c5nKmxXAz0Oa5Unnke32vk/c6SVjv0oK5mKsO
	ev2FErCNrw/Xf0hSBDaC0TTmFhkAGQANjDYHXxBFtAgzJ+cyqDeN/dU8DzTaIsaRnTqjot9sXLy
	kh+M60e1x7ptEwpEGkgsLOLi5rg==
X-Google-Smtp-Source: AGHT+IGG/ugXWVgGpCxPMAP/Ccqb4aZBz8y38s1TLqki2W99KFPyOdEm7ffLjdVe1PWTT7lBgxduFT+JvaciNq7bwps=
X-Received: by 2002:a05:6512:1597:b0:52b:2031:4b93 with SMTP id
 2adb3069b0e04-52bab4ca9d7mr467209e87.4.1717532371055; Tue, 04 Jun 2024
 13:19:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240603223811.3815762-1-sboyd@kernel.org> <20240603223811.3815762-8-sboyd@kernel.org>
 <20240604130526.GA12945-robh@kernel.org> <cce5a85e48f35f5ad5464a2443ca972e.sboyd@kernel.org>
In-Reply-To: <cce5a85e48f35f5ad5464a2443ca972e.sboyd@kernel.org>
From: Rob Herring <robh@kernel.org>
Date: Tue, 4 Jun 2024 15:19:18 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+mGbW=4RbF+E1knvQco+5b1s7Tk8=2wyo9rT48Q=zkFQ@mail.gmail.com>
Message-ID: <CAL_Jsq+mGbW=4RbF+E1knvQco+5b1s7Tk8=2wyo9rT48Q=zkFQ@mail.gmail.com>
Subject: Re: [PATCH v5 07/11] dt-bindings: test: Add single clk consumer
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	devicetree@vger.kernel.org, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Saravana Kannan <saravanak@google.com>, Daniel Latypov <dlatypov@google.com>, 
	Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Maxime Ripard <maxime@cerno.tech>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 4, 2024 at 1:28=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wrot=
e:
>
> Quoting Rob Herring (2024-06-04 06:05:26)
> > On Mon, Jun 03, 2024 at 03:38:04PM -0700, Stephen Boyd wrote:
> > > Describe a binding for a device that consumes a single clk in DT. Thi=
s
> > > will initially be used by a KUnit test to clk_get() the clk registere=
d
> > > by of_fixed_clk_setup() and test that it is setup properly.
> > >
> > > Cc: Rob Herring <robh@kernel.org>
> > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> > > Cc: Conor Dooley <conor+dt@kernel.org>
> > > Cc: Brendan Higgins <brendan.higgins@linux.dev>
> > > Cc: David Gow <davidgow@google.com>
> > > Cc: Rae Moar <rmoar@google.com>
> > > Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> > > ---
> > >  .../test/test,single-clk-consumer.yaml        | 34 +++++++++++++++++=
++
> > >  1 file changed, 34 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/test/test,singl=
e-clk-consumer.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/test/test,single-clk-c=
onsumer.yaml b/Documentation/devicetree/bindings/test/test,single-clk-consu=
mer.yaml
> > > new file mode 100644
> > > index 000000000000..8c384c48707d
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/test/test,single-clk-consumer=
.yaml
> > > @@ -0,0 +1,34 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/test/test,single-clk-consumer.yam=
l#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Test consumer of a single clock
> > > +
> > > +maintainers:
> > > +  - Stephen Boyd <sboyd@kernel.org>
> > > +
> > > +description:
> > > +  A consumer of a single clock used in tests.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    const: test,single-clk-consumer
> >
> > I don't know if there's much value in defining bindings for tests. We
> > could alternatively make 'test,' opt out of everything. There's already
> > some support in dtschema for this with 'foo,'.
> >
> > I need something for the DT unittest as well.
> >
>
> Ok. So I should drop this patch and the other one that adds a binding
> for the fake clock provider?

Yes.

> And replace it with something that makes
> the test vendor prefix opt out of all checking? How is that done?  Some
> patch to dtschema directly?

Yes, but I just added it for you.

Rob
