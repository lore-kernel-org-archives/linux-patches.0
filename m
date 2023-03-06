Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A316FC5
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 19:35:45 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id cy23so43154718edb.12
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 11:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678131343;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2FmQ1RxA+JCTff+KO7AZZBMrry2RXo2PGbyJ+O+NTU=;
        b=IgkVBROv3k/h35WvaHptNCygGYO2EPnMtdR7pvqwoaJPJkuq35AReJMKjzOkyqo97k
         d10hVnjL1TvevWflF2/XuEulOj95BSf5LalJSesE815fg8ZyfVk3aSx82rMkQ0rZd5te
         r/rLj3dbOMZYOOMt2p23OUmY0uXawWA9eSMNNyR7GSfqOkOmwkKQI/CWhfdOBiMvCyI8
         GdNclN5XHOebDQmAE3zJKeYV0RKZ+SJ5q7wrols86UlW66zwJPSE9qfoYzDu/qi3quKd
         syFPy/kq2EjKRf6YXhxcN32eTugjJbC9lcj2BGpB0y+K0CIjBjwzIWfyOKqwDrRUJQk5
         nlvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678131343;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t2FmQ1RxA+JCTff+KO7AZZBMrry2RXo2PGbyJ+O+NTU=;
        b=RD0mN02xOqKbXtIptEHNgpocH/hNonAd9QfNsZf+0zZW0tt4jTFRrSwWdY/XMyKelm
         tbkTqtMnDEqHPRRHH0taSQ/tIhWNTnGvmDe1qD/fqif8mMhY/hK5HdggcTCOd69vsNyQ
         DWBUWT/EoLL09OkTXFzCz+W4UffRJFgyJ2BxPET31/QYeAK9lUmd79ioykXMOe/9pGvr
         +fKd0T4QpVJ+bLvR5n5W1UNjduDjYEMSRscI0Fn2ON4deujbR3hxkDXZ3b+JfaSjKUe+
         dtNdRWyrspWXfsNE1jKJaF0Tfb/1Wd79Wrtr80ee+XNnOAa8e7JGJmIscHQAaFR2Ilc7
         YVTA==
X-Gm-Message-State: AO0yUKX2hjYwLX9Fka30wGrwoNL35NxtQig82G46OI7aiOb2GAfQfHiF
	SzWZs21GN/c3m/Bn+F/yxq4=
X-Google-Smtp-Source: AK7set9FnRqj4wdi7KpzxrX8+EYM492qvgHgKOc71WHv9TSs29+Ns28onXcJgUAKen//D1i8sXWMfg==
X-Received: by 2002:a17:907:6da3:b0:878:50f7:a35a with SMTP id sb35-20020a1709076da300b0087850f7a35amr14881581ejc.72.1678131343499;
        Mon, 06 Mar 2023 11:35:43 -0800 (PST)
Received: from localhost (93-55-83-125.ip262.fastwebnet.it. [93.55.83.125])
        by smtp.gmail.com with ESMTPSA id fw20-20020a170907501400b00914fec9f40esm558931ejc.71.2023.03.06.11.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 11:35:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 06 Mar 2023 20:35:41 +0100
Message-Id: <CQZJWVOTWFL4.1PZ3DHSRFK0FJ@vincent-arch>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>
Cc: <linux-doc@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 1/2] docs: programming-language: remove mention of the
 Intel compiler
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
References: <20230306191712.230658-1-ojeda@kernel.org>
In-Reply-To: <20230306191712.230658-1-ojeda@kernel.org>

> The Intel compiler support has been removed in commit 95207db8166a
> ("Remove Intel compiler support").
>
> Thus remove its mention in the Documentation too.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
