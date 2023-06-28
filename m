Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22B210EE
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 23:17:52 +0000 (UTC)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-991c786369cso9152766b.1
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 16:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1687994270; x=1690586270;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oM8+DBVW7RHSb20wzupU3eI3vgm5LTctM5Hspz2fXBo=;
        b=O+RjZHup1gFUy9V4mn0kHv6Wz+Pn2BnXSSfFOmq3h6jfKFFdP+kP+IWOmgdpRwUjXT
         e+Ynvpj4GJpkYUmMG4Ra9nDRpECU5eYgpQnpr+HD5PirCdrHTGoSoVJ/wtMjPtRhe/08
         xXkeeYifO/Lq5gKzfd/uhfTvToBI5+9RtN5cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687994270; x=1690586270;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oM8+DBVW7RHSb20wzupU3eI3vgm5LTctM5Hspz2fXBo=;
        b=i8KKVPniXUZcqh9YBTfpA5p6Pu8QtNC1bN85Sy1YxuueGvhzunHNZ544HCTCsi+BnI
         KcXVZsyTTebBzILv4NPsZ64mDUhsRmNA6PgcKRGJV2J/u5v2VrMXz+kypbhcZ8wocEBE
         fM4Uyn3Rvoce+8dDVrgA3zvh3FU0LvMamf2RhTs61QIvcL7oyzDoJzGFc2R+fo7PwkO9
         0vacKX0wu9jwhbbKhCK1WI5PVrOJec1Il38PoYj+jWKzp46HnYQJ1TlSAU7Vwlf/4gRk
         VUhUqrxO914L9SJVaqk8KZi8bg5HwlYn3J8xnqLPg4ubXie0VS8jc0QI+eVVaaQ9Huy4
         uxxQ==
X-Gm-Message-State: AC+VfDwpDfkxCKEWgV6oOvQamDbxemAKnsSNalX1bFTObe6zpmdCjoKy
	jiIKIj+dKS4lrdUf8mSRfzZpIS4I1SP0ODnoOuclu0dh
X-Google-Smtp-Source: ACHHUZ5B/50i7mVRxVcUyLrVhCQ2F0KG0O75z72H4IK3j2jQi3pPN/dnvV7NjN1YudVtSyizKTV/Bw==
X-Received: by 2002:a17:906:fd8e:b0:982:c69c:8c30 with SMTP id xa14-20020a170906fd8e00b00982c69c8c30mr30400086ejb.55.1687994270563;
        Wed, 28 Jun 2023 16:17:50 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id r24-20020a1709067fd800b009890f2c4cf9sm6200313ejs.79.2023.06.28.16.17.49
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 16:17:49 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-98df3dea907so8122266b.3
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 16:17:49 -0700 (PDT)
X-Received: by 2002:a19:380f:0:b0:4f8:4177:e087 with SMTP id
 f15-20020a19380f000000b004f84177e087mr20100079lfa.47.1687994248313; Wed, 28
 Jun 2023 16:17:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZHTCK2_1pF61yWIr@hovoldconsulting.com> <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
 <ZHYitt7P7W+8ZlSB@bombadil.infradead.org> <499e30cc-d015-8353-1364-50d17da58f47@redhat.com>
 <ZHd8bLPY4OQCb/Z5@bombadil.infradead.org> <ba60bca6-b682-4c27-3c54-2512b6f16151@redhat.com>
 <ZHoTFDkPIgglW0sU@bombadil.infradead.org> <fa3f1a1f-edc6-f13b-cc84-f3264b03b0b1@redhat.com>
 <ZH38lpTHZ/RISC1v@bombadil.infradead.org> <ZH3/KVCHhX4D4yh9@bombadil.infradead.org>
 <ZJyBhv6yrAfYvMh5@bombadil.infradead.org> <CAHk-=wiSRTEOgiDA5qUTPGcw=Fbk9Ou2i97kfSBcj3pey3X=fQ@mail.gmail.com>
 <CAHk-=wgPz4Fj9M_h7sRSHAK9QeJiTFaYMWX3fDyZ-Bj41HftmA@mail.gmail.com>
In-Reply-To: <CAHk-=wgPz4Fj9M_h7sRSHAK9QeJiTFaYMWX3fDyZ-Bj41HftmA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Jun 2023 16:17:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh80e=+_6UrHLdXMbJJ58Jz2YtMidc95HBT8raNy325nQ@mail.gmail.com>
Message-ID: <CAHk-=wh80e=+_6UrHLdXMbJJ58Jz2YtMidc95HBT8raNy325nQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, song@kernel.org, Johan Hovold <johan@kernel.org>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, Petr Pavlu <petr.pavlu@suse.com>, 
	gregkh@linuxfoundation.org, rafael@kernel.org, lucas.de.marchi@gmail.com, 
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org, 
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, mhocko@suse.com, 
	dave.hansen@linux.intel.com, colin.i.king@gmail.com, jim.cromie@gmail.com, 
	catalin.marinas@arm.com, jbaron@akamai.com, rick.p.edgecombe@intel.com, 
	yujie.liu@intel.com, tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com, 
	lennart@poettering.net
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Jun 2023 at 15:07, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Anyway, since I clearly didn't communicate clearly that I was throwing
> the patch over to you, let me go and find it and just apply it myself.

Ok, I spent some time writing a better commit message for that change,
tried to make sure I got everybody's comments and Tested-by's sorted
out etc, and committed the end result.

I also did the actual module pull and your sysctl pull.

Can you please check that it all looks like you expected?

              Linus
