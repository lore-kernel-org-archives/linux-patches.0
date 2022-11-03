Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4EC6FB8
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 11:32:39 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id e129so1391010pgc.9
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 04:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nAit4lW/Y7K4OiEt/2A6hbG4wE0H6oWTMpsWBScdOwI=;
        b=RnU7CuTDMBxLKqrKpkKadWFbSMUkQXJw1H5MNc3KNd3sIPnwbFoE6oDf8NCCV1sG21
         mDRD8po6CcI4lZoGWPmUFR0Sx3NnscnmVpTC+Wmyy1AB9XdxkmFWBXCNcPBZFiRzYtqR
         w6kzwfLBtIEPW23WAWhrVMwpY0BB2YY2wtgTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nAit4lW/Y7K4OiEt/2A6hbG4wE0H6oWTMpsWBScdOwI=;
        b=qBrV/zmbrC/fOUCEEEOj37YH+zpbzOSoa9YuQqW+lM9M3cNmmz+5bgI0gpygtY21X2
         PvWbNoePgQnG71gEkolk0rLx/bHg2KdDMqSJeo4wQFRQB5mXDYOoIt+kzo97uTdGerSC
         KuAlYqAg1sNh1fNjl+o/6MZjpl9uyBaKLZY9UNuiz73Zep5+CGG/JWAsM7dCzljSQOmU
         raGPT5EbKDxqdG85VwXJWDfUEZjY73pzoSpjB88QJ+O/F5OQf1Zy7xHEjEBPEUBVJYv4
         T6JfLf0Tihn0+Qhc1eXUq0cPZlAjRtVp0t1fo4hFftUL6JjeJao1xW3TgaRVgVlNjMoD
         vjFg==
X-Gm-Message-State: ACrzQf0mHyrJn+K4Kvi4eCX0QU9lO/yyAOMWe99BVr5jtWyHhQjWFpAA
	LC+wcq7+eRxMFXw4fo9gHg3MAIEyax4GV3ZpD/YuQiURBWUCtDVLuqgcgQK+5pAr8/aUjGa62wH
	FIhngVqhKJTM/oLxAXR9O3UiC
X-Google-Smtp-Source: AMsMyM7bRPU4s7jvMhwyAukTmMb3AnRM70Mec9EUlUJ1u4d2rgk33/IpQGEsSevoc1Co+CavHFkpRDmPuSUE50ftZj4=
X-Received: by 2002:a63:7f1a:0:b0:46f:8464:3019 with SMTP id
 a26-20020a637f1a000000b0046f84643019mr24373238pgd.450.1667475158553; Thu, 03
 Nov 2022 04:32:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221102161906.2781508-1-nathan@kernel.org> <202211021208.055D396D8E@keescook>
In-Reply-To: <202211021208.055D396D8E@keescook>
From: Ram Kishore Vegesna <ram.vegesna@broadcom.com>
Date: Thu, 3 Nov 2022 17:02:27 +0530
Message-ID: <CAF7aS0re7+wza6347zNweB==02GCvFk=H7N8OiQU7HPB1SPz7A@mail.gmail.com>
Subject: Re: [PATCH] scsi: elx: libefc: Fix second parameter type in state callbacks
To: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>, James Smart <james.smart@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000085b20105ec8f501f"

--00000000000085b20105ec8f501f
Content-Type: multipart/alternative; boundary="0000000000007fcf2905ec8f50cc"

--0000000000007fcf2905ec8f50cc
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 3, 2022 at 12:38 AM Kees Cook <keescook@chromium.org> wrote:

> On Wed, Nov 02, 2022 at 09:19:06AM -0700, Nathan Chancellor wrote:
> > With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> > indirect call targets are validated against the expected function
> > pointer prototype to make sure the call target is valid to help mitigate
> > ROP attacks. If they are not identical, there is a failure at run time,
> > which manifests as either a kernel panic or thread getting killed. A
> > proposed warning in clang aims to catch these at compile time, which
> > reveals:
> >
> >   drivers/scsi/elx/libefc/efc_node.c:811:22: error: incompatible
> function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32,
> void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from
> 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)'
> [-Werror,-Wincompatible-function-pointer-types-strict]
> >                   ctx->current_state = state;
> >                                     ^ ~~~~~
> >   drivers/scsi/elx/libefc/efc_node.c:878:21: error: incompatible
> function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32,
> void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from
> 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)'
> [-Werror,-Wincompatible-function-pointer-types-strict]
> >           node->nodedb_state = state;
> >                             ^ ~~~~~
> >   drivers/scsi/elx/libefc/efc_node.c:905:6: error: incompatible function
> pointer types assigning to 'void (*)(struct efc_sm_ctx *, enum
> efc_sm_event, void *)' from 'void (*)(struct efc_sm_ctx *, u32, void *)'
> (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)')
> [-Werror,-Wincompatible-function-pointer-types-strict]
> >                   pf = node->nodedb_state;
> >                     ^ ~~~~~~~~~~~~~~~~~~
> >
> >   drivers/scsi/elx/libefc/efc_device.c:455:22: error: incompatible
> function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32,
> void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from
> 'void (struct efc_sm_ctx *, enum efc_sm_event, void *)'
> [-Werror,-Wincompatible-function-pointer-types-strict]
> >                   node->nodedb_state = __efc_d_init;
> >                                     ^ ~~~~~~~~~~~~
> >
> >   drivers/scsi/elx/libefc/efc_sm.c:41:22: error: incompatible function
> pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)'
> (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void
> (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)'
> [-Werror,-Wincompatible-function-pointer-types-strict]
> >                   ctx->current_state = state;
> >                                     ^ ~~~~~
> >
> > The type of the second parameter in the prototypes of ->current_state()
> > and ->nodedb_state() ('u32') does not match the implementations, which
> > have a second parameter type of 'enum efc_sm_event'. Update the
> > prototypes to have the correct second parameter type, clearing up all
> > the warnings and CFI failures.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> > Reported-by: Sami Tolvanen <samitolvanen@google.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> --
> Kees Cook
>

Looks good.

Reviewed-by: Ram Vegesna<ram.vegesna@broadcom.com>

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000007fcf2905ec8f50cc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div>On Thu, Nov 3, 2022 at 12:38 AM Kees=
 Cook &lt;<a href=3D"mailto:keescook@chromium.org">keescook@chromium.org</a=
>&gt; wrote:<br></div></div><div class=3D"gmail_quote"><blockquote class=3D=
"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(2=
04,204,204);padding-left:1ex">On Wed, Nov 02, 2022 at 09:19:06AM -0700, Nat=
han Chancellor wrote:<br>
&gt; With clang&#39;s kernel control flow integrity (kCFI, CONFIG_CFI_CLANG=
),<br>
&gt; indirect call targets are validated against the expected function<br>
&gt; pointer prototype to make sure the call target is valid to help mitiga=
te<br>
&gt; ROP attacks. If they are not identical, there is a failure at run time=
,<br>
&gt; which manifests as either a kernel panic or thread getting killed. A<b=
r>
&gt; proposed warning in clang aims to catch these at compile time, which<b=
r>
&gt; reveals:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0drivers/scsi/elx/libefc/efc_node.c:811:22: error: incompat=
ible function pointer types assigning to &#39;void (*)(struct efc_sm_ctx *,=
 u32, void *)&#39; (aka &#39;void (*)(struct efc_sm_ctx *, unsigned int, vo=
id *)&#39;) from &#39;void (*)(struct efc_sm_ctx *, enum efc_sm_event, void=
 *)&#39; [-Werror,-Wincompatible-function-pointer-types-strict]<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct=
x-&gt;current_state =3D state;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^ ~~~~~<br>
&gt;=C2=A0 =C2=A0drivers/scsi/elx/libefc/efc_node.c:878:21: error: incompat=
ible function pointer types assigning to &#39;void (*)(struct efc_sm_ctx *,=
 u32, void *)&#39; (aka &#39;void (*)(struct efc_sm_ctx *, unsigned int, vo=
id *)&#39;) from &#39;void (*)(struct efc_sm_ctx *, enum efc_sm_event, void=
 *)&#39; [-Werror,-Wincompatible-function-pointer-types-strict]<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0node-&gt;nodedb_state =3D stat=
e;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^ ~~~~~<br>
&gt;=C2=A0 =C2=A0drivers/scsi/elx/libefc/efc_node.c:905:6: error: incompati=
ble function pointer types assigning to &#39;void (*)(struct efc_sm_ctx *, =
enum efc_sm_event, void *)&#39; from &#39;void (*)(struct efc_sm_ctx *, u32=
, void *)&#39; (aka &#39;void (*)(struct efc_sm_ctx *, unsigned int, void *=
)&#39;) [-Werror,-Wincompatible-function-pointer-types-strict]<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pf=
 =3D node-&gt;nodedb_state;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0^ ~~~~~~~~~~~~~~~~~~<br>
&gt; <br>
&gt;=C2=A0 =C2=A0drivers/scsi/elx/libefc/efc_device.c:455:22: error: incomp=
atible function pointer types assigning to &#39;void (*)(struct efc_sm_ctx =
*, u32, void *)&#39; (aka &#39;void (*)(struct efc_sm_ctx *, unsigned int, =
void *)&#39;) from &#39;void (struct efc_sm_ctx *, enum efc_sm_event, void =
*)&#39; [-Werror,-Wincompatible-function-pointer-types-strict]<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0no=
de-&gt;nodedb_state =3D __efc_d_init;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^ ~~~~~~~~~~~=
~<br>
&gt; <br>
&gt;=C2=A0 =C2=A0drivers/scsi/elx/libefc/efc_sm.c:41:22: error: incompatibl=
e function pointer types assigning to &#39;void (*)(struct efc_sm_ctx *, u3=
2, void *)&#39; (aka &#39;void (*)(struct efc_sm_ctx *, unsigned int, void =
*)&#39;) from &#39;void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)=
&#39; [-Werror,-Wincompatible-function-pointer-types-strict]<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct=
x-&gt;current_state =3D state;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^ ~~~~~<br>
&gt; <br>
&gt; The type of the second parameter in the prototypes of -&gt;current_sta=
te()<br>
&gt; and -&gt;nodedb_state() (&#39;u32&#39;) does not match the implementat=
ions, which<br>
&gt; have a second parameter type of &#39;enum efc_sm_event&#39;. Update th=
e<br>
&gt; prototypes to have the correct second parameter type, clearing up all<=
br>
&gt; the warnings and CFI failures.<br>
&gt; <br>
&gt; Link: <a href=3D"https://github.com/ClangBuiltLinux/linux/issues/1750"=
 rel=3D"noreferrer" target=3D"_blank">https://github.com/ClangBuiltLinux/li=
nux/issues/1750</a><br>
&gt; Reported-by: Sami Tolvanen &lt;<a href=3D"mailto:samitolvanen@google.c=
om" target=3D"_blank">samitolvanen@google.com</a>&gt;<br>
&gt; Signed-off-by: Nathan Chancellor &lt;<a href=3D"mailto:nathan@kernel.o=
rg" target=3D"_blank">nathan@kernel.org</a>&gt;<br>
<br>
Reviewed-by: Kees Cook &lt;<a href=3D"mailto:keescook@chromium.org" target=
=3D"_blank">keescook@chromium.org</a>&gt;<br>
<br>
-- <br>
Kees Cook<br></blockquote><div>=C2=A0</div>Looks good.<div><br></div><div>R=
eviewed-by: Ram Vegesna&lt;<a href=3D"mailto:ram.vegesna@broadcom.com" targ=
et=3D"_blank">ram.vegesna@broadcom.com</a>&gt;=C2=A0</div></div></div>

<br>
<span style=3D"background-color:rgb(255,255,255)"><font size=3D"2">This ele=
ctronic communication and the information and any files transmitted with it=
, or attached to it, are confidential and are intended solely for the use o=
f the individual or entity to whom it is addressed and may contain informat=
ion that is confidential, legally privileged, protected by privacy laws, or=
 otherwise restricted from disclosure to anyone else. If you are not the in=
tended recipient or the person responsible for delivering the e-mail to the=
 intended recipient, you are hereby notified that any use, copying, distrib=
uting, dissemination, forwarding, printing, or copying of this e-mail is st=
rictly prohibited. If you received this e-mail in error, please return the =
e-mail to the sender, delete it from your computer, and destroy any printed=
 copy of it.</font></span>
--0000000000007fcf2905ec8f50cc--

--00000000000085b20105ec8f501f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2zA9Cvc2rwq0eYy3MYtZhjNCQpspl2TQzcola/juDFoyAUF7D9OD7Pf0AH9yqa4tSkLGGWxzLPCL
6PIePC2XJcbFjRDx1wpfOdjQOdEsYF+yMgzXXSp8tqLdh5LM5ZcCAwEAAaOCAdkwggHVMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
IwYDVR0RBBwwGoEYcmFtLnZlZ2VzbmFAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwME
MB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBQaZQNNYUHOrXVDGMoR
3NybyZ4hAzANBgkqhkiG9w0BAQsFAAOCAQEARGZ6BqecpGQZa9HtRmQ0Tw8E3Wism01tm7fybzIV
JNxaSaFOp6bqOMPpRdO7XVAmvMHUX6NvgBS2xURWKhHi7yU7pXIOPnheGgUrVIYa8KRy/+5MWD54
0pKhwqS5gkHzwk47+u3HNIhr2wFbDbK0Vei2AUf1ICRwJQ1PDG9+LYRCIJZqv5EaDtJ1KhzU6H2+
wK4tdCNKvWy8nHgPw4+x25QIGk+ur66gc+8nY2Y3iejwIGjEjzoKlG6v8jm6Yt/1jnjJltAev6R6
bHCB3GzEib7aU2IBQ/Jv3bCf7h18Xl0j03xE6sJfZkU7u4DTF8njoco30Y4vvdQHAttklJkJLDGC
Am0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExMTAv
BgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDBqPumG2a5F2
dafbHDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgK+t/Ad19dYRjKLvNiTSNTfXO
7SrvhtCe+sB6E4UbZ+owGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
MjIxMTAzMTEzMjM4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYw
CwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAD+AWyoFL4sca/jIgWGmuKt54MR4mIw69fS9P1YlxVYt
PQtWOiRrgcf6fCranLroPRPYZI0H626TZzomzI9an1wxu1qifIfmysjAeGk1Ps1kfZRUzu13uQAQ
fdbr8dLIEpBfgTaI5Zze7OnADm4qJ/KKL6sXUpmnMDTeIYXBLlbI037Lr0JOe3HOQIOIfU2VSrdd
yraDsanUXdDHdj/+LfI0jrMnilvAgBlAC9ctLix5VJOxkMITd4AV/4DLkBBIIAQam+qy0j7ZbrZM
4nqzE+bNc2ZeB3qFI5eSeLUDsM/N0Eqh723fKxRrLnxvDY5g9SUIq4/wz4Et+DjfDCAgm0w=
--00000000000085b20105ec8f501f--
