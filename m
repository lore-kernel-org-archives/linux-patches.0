Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21E91FB0
	for <patches@lists.linux.dev>; Thu, 25 May 2023 04:00:22 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-96f850b32caso19523066b.3
        for <patches@lists.linux.dev>; Wed, 24 May 2023 21:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1684987221; x=1687579221;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M9wvkrHiO2vLfdNjz3Lr8jzqTeFi37UzWEdwoU59g04=;
        b=bnxg4h+mNmRYiXas5ZvZAoTUKlW0oSZMY41eO78AXWHgge+S4fps6qkDH3ihsMNRju
         yXm12T+cPoE0bwFHHRxkNhtoJYdT162geAjeWuYQU/40BuJT9x3rl9LdIRq6F2sl2hVG
         kNkrGof9BO0HccaRDhimxz8nV90ec8V0hS0QU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684987221; x=1687579221;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M9wvkrHiO2vLfdNjz3Lr8jzqTeFi37UzWEdwoU59g04=;
        b=E+qln6MrL+VGPW079SrUXZiS3ghUE284gOSOR1iShYXqwvsMP2CIe3hKWSea083JtF
         xo7Qp1p0I+DtS6JNsZM1EK+/e8jvUjKQTtS6jSPllQBv5oouucc7XBwseF+sdmymIrx2
         CuBFoli0ktNqH4AHm9nY+EkE/WZBVrUFkIdXc/WkBL3ymvqNOfFQ/HbVmz4ydYZfM2LJ
         vhMHLl8fxB/LGjlO4TwyKVSi8pFhz2iUaHTUWJnT/bxST7pzKvFFQh3HgSQ7PnH56y6Q
         aAoIY+Bl0DWc7Lj/P1I+DtJ/rWjbogYDtdBOrYD5eqGIKnIbm2zxVjw5Lbbo1vLir3gq
         Yo8w==
X-Gm-Message-State: AC+VfDx+cwrhx0JFMoVQBooGTwYQsSIRXfv6INgMItr3oxRlQ3Uof2DM
	YEUgA4jXRmPjCFGdVXJCUGTa0k7icQw06G3/RBZBGeJH
X-Google-Smtp-Source: ACHHUZ6KLJdLc/QIrJIVjFgxcTp3qw9sP6CNhpMsAxmPsK86B5gV8wqbBPEd0Xu0PXkA/JBFslF3dw==
X-Received: by 2002:a17:907:961e:b0:93e:fa12:aa1a with SMTP id gb30-20020a170907961e00b0093efa12aa1amr305420ejc.1.1684987220596;
        Wed, 24 May 2023 21:00:20 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id qw23-20020a170906fcb700b0096f71ace804sm250022ejb.99.2023.05.24.21.00.19
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 21:00:19 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-9707313e32eso19598666b.2
        for <patches@lists.linux.dev>; Wed, 24 May 2023 21:00:19 -0700 (PDT)
X-Received: by 2002:a17:907:985:b0:968:4ce9:677a with SMTP id
 bf5-20020a170907098500b009684ce9677amr154847ejc.38.1684987218743; Wed, 24 May
 2023 21:00:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-1-mcgrof@kernel.org> <20230524213620.3509138-2-mcgrof@kernel.org>
 <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 May 2023 21:00:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgKu=tJf1bm_dtme4Hde4zTB=_7EdgR8avsDRK4_jD+uA@mail.gmail.com>
Message-ID: <CAHk-=wgKu=tJf1bm_dtme4Hde4zTB=_7EdgR8avsDRK4_jD+uA@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/kernel_read_file: add support for duplicate detection
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com, 
	prarit@redhat.com, lennart@poettering.net, gregkh@linuxfoundation.org, 
	rafael@kernel.org, song@kernel.org, lucas.de.marchi@gmail.com, 
	lucas.demarchi@intel.com, christophe.leroy@csgroup.eu, peterz@infradead.org, 
	rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, 
	mhocko@suse.com, dave.hansen@linux.intel.com, colin.i.king@gmail.com, 
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com, 
	rick.p.edgecombe@intel.com, yujie.liu@intel.com
Content-Type: multipart/mixed; boundary="000000000000a047aa05fc7ca823"

--000000000000a047aa05fc7ca823
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 2:52=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is all disgusting.

Bringing back the original thread, because I just sent an alternate
patch to Luis to test.

That one is also disgusting, but for different reasons: it needs some
polish if it works. It's a very simple patch, in that it just extends
our existing i_writecount and ETXTBSY logic to also have a "exclusive"
mode, and says that we do the module file reading in that exclusive
mode (so if/when udev in its incompetence tries to load the same
module X number of times at the same time, only one will read at a
time).

The disgusting part is mainly the hacky test for "id =3D=3D
READING_MODULE", and it would probably be better with some kind of
"exclusive flag" field for general use, but right now READING_MODULE
is basically that one user.

Luis having explained _why_ we'd want this (and honestly, it took a
couple of tries), I can only say that udev is horribly broken, and
this most definitely should be fixed in user mode. udev randomly
loading the same module multiple times just because it gets confused
is not ok.

Any udev developer that goes "we can't fix it in user space" should be
ashamed of themselves. Really? Just randomly doing the same thing in
parallel and expecting the kernel to sort out your mess? What a crock.

But this *might* mitigate that udev horror. And not introduce any new
kernel-side horror, just a slight extension of our existing writer
exclusion logic to allow "full exclusive access".

(Note: it's not actually excluding other purely regular readers - but
it *is* excluding not just writers, but also other "special readers"
that want to exclude writers)

I'd like to point out that this patch really is completely untested.
It built for me, but that's all the testing it has gotten. It's
_small_. Tiny, even. But that "id =3D=3D READING_MODULE" thing really is
pretty disgusting and I feel this needs more thought.

                         Linus

--000000000000a047aa05fc7ca823
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_li2ltl2y0>
X-Attachment-Id: f_li2ltl2y0

IGZzL2tlcm5lbF9yZWFkX2ZpbGUuYyB8IDYgKysrKystCiBpbmNsdWRlL2xpbnV4L2ZzLmggICAg
fCA2ICsrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pCgpkaWZmIC0tZ2l0IGEvZnMva2VybmVsX3JlYWRfZmlsZS5jIGIvZnMva2VybmVsX3JlYWRf
ZmlsZS5jCmluZGV4IDVkODI2Mjc0NTcwYy4uZmYzZTg5NGY4Y2Q0IDEwMDY0NAotLS0gYS9mcy9r
ZXJuZWxfcmVhZF9maWxlLmMKKysrIGIvZnMva2VybmVsX3JlYWRfZmlsZS5jCkBAIC00OCw3ICs0
OCwxMSBAQCBzc2l6ZV90IGtlcm5lbF9yZWFkX2ZpbGUoc3RydWN0IGZpbGUgKmZpbGUsIGxvZmZf
dCBvZmZzZXQsIHZvaWQgKipidWYsCiAJaWYgKCFTX0lTUkVHKGZpbGVfaW5vZGUoZmlsZSktPmlf
bW9kZSkpCiAJCXJldHVybiAtRUlOVkFMOwogCi0JcmV0ID0gZGVueV93cml0ZV9hY2Nlc3MoZmls
ZSk7CisJLyogTW9kdWxlIHJlYWRpbmcgd2FudHMgKmV4Y2x1c2l2ZSogYWNjZXNzIHRvIHRoZSBm
aWxlICovCisJaWYgKGlkID09IFJFQURJTkdfTU9EVUxFKQorCQlyZXQgPSBleGNsdXNpdmVfZGVu
eV93cml0ZV9hY2Nlc3MoZmlsZSk7CisJZWxzZQorCQlyZXQgPSBkZW55X3dyaXRlX2FjY2Vzcyhm
aWxlKTsKIAlpZiAocmV0KQogCQlyZXR1cm4gcmV0OwogCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L2ZzLmggYi9pbmNsdWRlL2xpbnV4L2ZzLmgKaW5kZXggMjFhOTgxNjgwODU2Li43MjJiNDJh
NzdkNTEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvZnMuaAorKysgYi9pbmNsdWRlL2xpbnV4
L2ZzLmgKQEAgLTI1NjYsNiArMjU2NiwxMiBAQCBzdGF0aWMgaW5saW5lIGludCBkZW55X3dyaXRl
X2FjY2VzcyhzdHJ1Y3QgZmlsZSAqZmlsZSkKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZV9p
bm9kZShmaWxlKTsKIAlyZXR1cm4gYXRvbWljX2RlY191bmxlc3NfcG9zaXRpdmUoJmlub2RlLT5p
X3dyaXRlY291bnQpID8gMCA6IC1FVFhUQlNZOwogfQorc3RhdGljIGlubGluZSBpbnQgZXhjbHVz
aXZlX2Rlbnlfd3JpdGVfYWNjZXNzKHN0cnVjdCBmaWxlICpmaWxlKQoreworCWludCBvbGQgPSAw
OworCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBmaWxlX2lub2RlKGZpbGUpOworCXJldHVybiBhdG9t
aWNfdHJ5X2NtcHhjaGcoJmlub2RlLT5pX3dyaXRlY291bnQsICZvbGQsIC0xKSA/IDAgOiAtRVRY
VEJTWTsKK30KIHN0YXRpYyBpbmxpbmUgdm9pZCBwdXRfd3JpdGVfYWNjZXNzKHN0cnVjdCBpbm9k
ZSAqIGlub2RlKQogewogCWF0b21pY19kZWMoJmlub2RlLT5pX3dyaXRlY291bnQpOwo=
--000000000000a047aa05fc7ca823--
