Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA16D530
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 20:09:33 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-17e140619fdso8928098fac.11
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 13:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679429373;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IoD7Q9QgP9epdBdXgrVu+8obbfapCzV9cQyqFydqE4=;
        b=a4ENMVaPUX+7boNECUGISoVI3Bs8JgZJGN9UlAlt2bqutFdxP/2MNbw7J9qYhPvbro
         2J0e3yCLIqGlRWM1sNwXtktPmD9FjgvFtBq9QireIE2Fpmn1v+sbCuncmpI5u5cJismn
         JyGmxvgg3LFP6BBneIyndHmoJwWR/ih7j9EjOb6WsNTQPusRRjbwqu4icPircrZEkUFo
         bSox65kx/e9ulPORR/2ZraPyZkpO7zf8f7zdrZiThGAN4Bw+Ei3vZ2lFGHqoqiJmMO9S
         sHqkCVpbGiVESsKKY0qHbzx8LWBnSMqxYNZ9dc6wfO7ublpiabGd/PDd8MkL2lYGKyxU
         SC6w==
X-Gm-Message-State: AO0yUKWwbfdQlVvIHac12tf/3IZUNCaxpJECvnOxdy4r/DG/mAjWwFE5
	/vAtUbI7iA9F+ZaLFPMeug==
X-Google-Smtp-Source: AK7set+pWW0vALEw83DoZDfRZdCvrXXnxgvVR/oSATJR6uJ8gLmhh0iJscB+wyFEqdciz39XeohXEA==
X-Received: by 2002:a05:6871:413:b0:179:d821:b911 with SMTP id d19-20020a056871041300b00179d821b911mr165631oag.21.1679429372840;
        Tue, 21 Mar 2023 13:09:32 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id wl24-20020a056871a81800b0017255c79736sm4541598oab.43.2023.03.21.13.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 13:09:32 -0700 (PDT)
Received: (nullmailer pid 1397876 invoked by uid 1000);
	Tue, 21 Mar 2023 20:09:31 -0000
Date: Tue, 21 Mar 2023 15:09:31 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH v2 04/11] dt-bindings: test: Add KUnit empty node binding
Message-ID: <20230321200931.GA1367503-robh@kernel.org>
References: <20230315183729.2376178-1-sboyd@kernel.org>
 <20230315183729.2376178-5-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315183729.2376178-5-sboyd@kernel.org>

On Wed, Mar 15, 2023 at 11:37:21AM -0700, Stephen Boyd wrote:
> Describe a binding for an empty device node used by KUnit tests to
> confirm overlays load properly.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Cc: David Gow <davidgow@google.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  .../bindings/test/test,kunit-empty.yaml       | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/test/test,kunit-empty.yaml
> 
> diff --git a/Documentation/devicetree/bindings/test/test,kunit-empty.yaml b/Documentation/devicetree/bindings/test/test,kunit-empty.yaml
> new file mode 100644
> index 000000000000..592fd06031b8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/test/test,kunit-empty.yaml
> @@ -0,0 +1,30 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/clock/test,kunit-empty.yaml#

s/clock/test/

'make dt_binding_check' will tell you this.

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: KUnit empty node
> +
> +maintainers:
> +  - David Gow <davidgow@google.com>
> +  - Brendan Higgins <brendanhiggins@google.com>
> +
> +description: |

Don't need '|'

> +  An empty node to confirm KUnit can load device tree overlays.
> +
> +properties:
> +  compatible:
> +    const: test,kunit-empty
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    kunit-node {
> +      compatible = "test,kunit-empty";
> +    };
> +...
> -- 
> https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
> https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git
> 
