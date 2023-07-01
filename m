Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157A615CC
	for <patches@lists.linux.dev>; Sat,  1 Jul 2023 01:32:37 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-98df6bc0048so287795366b.1
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 18:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688175156; x=1690767156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lmQawnZPImWl2SD6T1qGl5AoepWm79fi28WZcuSJ8jI=;
        b=KKhpe8OVghm02SswfR/STaWbLwOakDiapgoRoUT1Go9cwm5ZXKZZLuu21k/PDocrft
         Xz5vj3DBAa2T/k3T5sViCAFGep60HGCnv//o7QoWFXRHI64Mk8RJbtjBQ1Z5X78cyrrW
         VU7S6ZnGk6MVMci8905QZoDAb2uVot47HuMKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688175156; x=1690767156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmQawnZPImWl2SD6T1qGl5AoepWm79fi28WZcuSJ8jI=;
        b=QdW8Fr3AHtNot3mGBzBdf1lwsq9HhQ+Ytpl3N2HRk/CVhD/QASt3D8hB6BNjf/fFRc
         4aIicMWlIaEnhj3j5Qh54tP8P+J0Vl3L/JYBri0V+Ae33y0g+FbA6jd+ppLC4BRSKyeR
         SpOkkL9cRQEFFHF+M4COBoLA/skdh4NJmGvGh5X5Nj9VJcSV/YPeHWqnM82OQLx3xFI2
         LN1bgW4TxqWciUCyHP8qkwqL7TsV1nKF1PjyE3+Fo9IR5JNM0YkfLZUJJaeTlRvbZ//z
         SK2cLBZ3ezRm68Qm9C4+kbQwq92kpZABtHDXkgytKqjB9jG2w7r2L99AJslxNwLqsZY2
         HicA==
X-Gm-Message-State: ABy/qLZmUHzBp8sptWNQJG3JDg1gK5a+7SdCB0NYY/JYBctA4w7xXQXk
	gZAZ+JrPed8DhsYoviKQqDX19ktPqMu1bgMlR7EwoOBh
X-Google-Smtp-Source: APBJJlHKlHpcAAGqidsBvGcGrDpQ1+gVPJDZwV+ba5PhOXrBpFlWhWrKh9bw/AedBtcqcGzQG0WItA==
X-Received: by 2002:a17:906:4a54:b0:992:6e93:ce38 with SMTP id a20-20020a1709064a5400b009926e93ce38mr2757372ejv.41.1688175155887;
        Fri, 30 Jun 2023 18:32:35 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id mc15-20020a170906eb4f00b00992f1a3b9bfsm1080994ejb.170.2023.06.30.18.32.35
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 18:32:35 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-992f6d7c7fbso112609766b.3
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 18:32:35 -0700 (PDT)
X-Received: by 2002:a05:6512:2010:b0:4f8:e4e9:499e with SMTP id
 a16-20020a056512201000b004f8e4e9499emr2999983lfb.12.1688174706280; Fri, 30
 Jun 2023 18:25:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.888604958@linuxfoundation.org> <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
 <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net> <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
 <CAHk-=wiN5H-2dh2zCo_jXE7_ekrxSHvQcMw4xfUKjuQs2=BN4w@mail.gmail.com> <fb63ea7b-c44b-fb1b-2014-3d23794fa896@roeck-us.net>
In-Reply-To: <fb63ea7b-c44b-fb1b-2014-3d23794fa896@roeck-us.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Jun 2023 18:24:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whh_aUHYF6LCV36K9NYHR4ofEZ0gwcg0RY5hj=B7AT4YQ@mail.gmail.com>
Message-ID: <CAHk-=whh_aUHYF6LCV36K9NYHR4ofEZ0gwcg0RY5hj=B7AT4YQ@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
To: Guenter Roeck <linux@roeck-us.net>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, linux-parisc <linux-parisc@vger.kernel.org>, 
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Content-Type: multipart/mixed; boundary="000000000000b0e4fd05ff62cd63"

--000000000000b0e4fd05ff62cd63
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Jun 2023 at 15:51, Guenter Roeck <linux@roeck-us.net> wrote:
>
> There is one more, unfortunately.
>
> Building xtensa:de212:kc705-nommu:nommu_kc705_defconfig ... failed

Heh. I didn't even realize that anybody would ever do
lock_mm_and_find_vma() code on a nommu platform.

With nommu, handle_mm_fault() will just BUG(), so it's kind of
pointless to do any of this at all, and I didn't expect anybody to
have this page faulting path that just causes that BUG() for any
faults.

But it turns out xtensa has a notion of protection faults even for
NOMMU configs:

    config PFAULT
        bool "Handle protection faults" if EXPERT && !MMU
        default y
        help
          Handle protection faults. MMU configurations must enable it.
          noMMU configurations may disable it if used memory map never
          generates protection faults or faults are always fatal.

          If unsure, say Y.

which is why it violated my expectations so badly.

I'm not sure if that protection fault handling really ever gets quite
this far (it certainly should *not* make it to the BUG() in
handle_mm_fault()), but I think the attached patch is likely the right
thing to do.

Can you check if it fixes that xtensa case? It looks
ObviouslyCorrect(tm) to me, but considering that I clearly missed this
case existing AT ALL, it might be best to double-check.

               Linus

--000000000000b0e4fd05ff62cd63
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_ljjbm8ha0>
X-Attachment-Id: f_ljjbm8ha0

IGluY2x1ZGUvbGludXgvbW0uaCB8ICA1ICsrKy0tCiBtbS9ub21tdS5jICAgICAgICAgfCAxMSAr
KysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW0uaCBiL2luY2x1ZGUvbGludXgvbW0u
aAppbmRleCAzOWFhNDA5ZTg0ZDUuLjRmMmMzM2MyNzNlYiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9s
aW51eC9tbS5oCisrKyBiL2luY2x1ZGUvbGludXgvbW0uaApAQCAtMjMyMyw2ICsyMzIzLDkgQEAg
dm9pZCBwYWdlY2FjaGVfaXNpemVfZXh0ZW5kZWQoc3RydWN0IGlub2RlICppbm9kZSwgbG9mZl90
IGZyb20sIGxvZmZfdCB0byk7CiB2b2lkIHRydW5jYXRlX3BhZ2VjYWNoZV9yYW5nZShzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBsb2ZmX3Qgb2Zmc2V0LCBsb2ZmX3QgZW5kKTsKIGludCBnZW5lcmljX2Vy
cm9yX3JlbW92ZV9wYWdlKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLCBzdHJ1Y3QgcGFn
ZSAqcGFnZSk7CiAKK3N0cnVjdCB2bV9hcmVhX3N0cnVjdCAqbG9ja19tbV9hbmRfZmluZF92bWEo
c3RydWN0IG1tX3N0cnVjdCAqbW0sCisJCXVuc2lnbmVkIGxvbmcgYWRkcmVzcywgc3RydWN0IHB0
X3JlZ3MgKnJlZ3MpOworCiAjaWZkZWYgQ09ORklHX01NVQogZXh0ZXJuIHZtX2ZhdWx0X3QgaGFu
ZGxlX21tX2ZhdWx0KHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLAogCQkJCSAgdW5zaWduZWQg
bG9uZyBhZGRyZXNzLCB1bnNpZ25lZCBpbnQgZmxhZ3MsCkBAIC0yMzM0LDggKzIzMzcsNiBAQCB2
b2lkIHVubWFwX21hcHBpbmdfcGFnZXMoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsCiAJ
CXBnb2ZmX3Qgc3RhcnQsIHBnb2ZmX3QgbnIsIGJvb2wgZXZlbl9jb3dzKTsKIHZvaWQgdW5tYXBf
bWFwcGluZ19yYW5nZShzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywKIAkJbG9mZl90IGNv
bnN0IGhvbGViZWdpbiwgbG9mZl90IGNvbnN0IGhvbGVsZW4sIGludCBldmVuX2Nvd3MpOwotc3Ry
dWN0IHZtX2FyZWFfc3RydWN0ICpsb2NrX21tX2FuZF9maW5kX3ZtYShzdHJ1Y3QgbW1fc3RydWN0
ICptbSwKLQkJdW5zaWduZWQgbG9uZyBhZGRyZXNzLCBzdHJ1Y3QgcHRfcmVncyAqcmVncyk7CiAj
ZWxzZQogc3RhdGljIGlubGluZSB2bV9mYXVsdF90IGhhbmRsZV9tbV9mYXVsdChzdHJ1Y3Qgdm1f
YXJlYV9zdHJ1Y3QgKnZtYSwKIAkJCQkJIHVuc2lnbmVkIGxvbmcgYWRkcmVzcywgdW5zaWduZWQg
aW50IGZsYWdzLApkaWZmIC0tZ2l0IGEvbW0vbm9tbXUuYyBiL21tL25vbW11LmMKaW5kZXggMzdk
MGIwMzE0M2YxLi5mZGMzOTI3MzVlYzYgMTAwNjQ0Ci0tLSBhL21tL25vbW11LmMKKysrIGIvbW0v
bm9tbXUuYwpAQCAtNjMwLDYgKzYzMCwxNyBAQCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKmZpbmRf
dm1hKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCB1bnNpZ25lZCBsb25nIGFkZHIpCiB9CiBFWFBPUlRf
U1lNQk9MKGZpbmRfdm1hKTsKIAorLyoKKyAqIEF0IGxlYXN0IHh0ZW5zYSBlbmRzIHVwIGhhdmlu
ZyBwcm90ZWN0aW9uIGZhdWx0cyBldmVuIHdpdGggbm8KKyAqIE1NVS4uIE5vIHN0YWNrIGV4cGFu
c2lvbiwgYXQgbGVhc3QuCisgKi8KK3N0cnVjdCB2bV9hcmVhX3N0cnVjdCAqbG9ja19tbV9hbmRf
ZmluZF92bWEoc3RydWN0IG1tX3N0cnVjdCAqbW0sCisJCQl1bnNpZ25lZCBsb25nIGFkZHIsIHN0
cnVjdCBwdF9yZWdzICpyZWdzKQoreworCW1tYXBfcmVhZF9sb2NrKG1tKTsKKwlyZXR1cm4gdm1h
X2xvb2t1cChtbSwgYWRkcik7Cit9CisKIC8qCiAgKiBleHBhbmQgYSBzdGFjayB0byBhIGdpdmVu
IGFkZHJlc3MKICAqIC0gbm90IHN1cHBvcnRlZCB1bmRlciBOT01NVSBjb25kaXRpb25zCg==
--000000000000b0e4fd05ff62cd63--
