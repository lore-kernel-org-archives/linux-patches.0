Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A7122627
	for <patches@lists.linux.dev>; Wed, 24 May 2023 21:53:10 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-513fea21228so3038413a12.3
        for <patches@lists.linux.dev>; Wed, 24 May 2023 14:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1684965189; x=1687557189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmM3xzgdi9y49uPixr7wck0B/tHNIYgDgFJoqWzjkEA=;
        b=EFmUHJDP3yEK6fzreA1VVsxZ2ysR/Ajv9q+IDmSm+q6CVoAzkcJZMissWcDrwj1NQ6
         q5nThWfTNAPqk6Q/6DZViHFD74/y2u3vRcFfpvi4Pc6eFd4B8JklF/0VhdUxUaqJldiU
         Z4Qsg8n5x0lLB+U57CQwVR/DOVOYqbSDBKs4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684965189; x=1687557189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GmM3xzgdi9y49uPixr7wck0B/tHNIYgDgFJoqWzjkEA=;
        b=QS5UUXvqZ8/F2ay2sEwq1Kg2+upiAJpUJsTjdzRimcsrKjh8+w0PugD/6Ged5bkvB0
         Epn5Zo9vYLzDQf4GaypagL1Prs6ds3q6wvC5hPUPMHz4wKfTtdNNn42IunOKPT5QVZOK
         4o3pjk+GEncBPi3rWRs8tfUK48R90Y6b0ToETx9TJt9joMfcolKz4HlsuiwAJbveqhUw
         jAvyLa1egWypaEhUdYrK9tnSbsDssck7aMmGK2BE0UACbHbCMopyyzZg1UoAGXGyO9UP
         xmI0mgEeGdoGL4ueRHgOiYeF8OpTlI3FEuKzgaB3/HOw5h/Gvs8vygIYSrT0WviT84Bd
         Ircg==
X-Gm-Message-State: AC+VfDyWY5j22h0ciFRQmhme7aYVde8ZK71bH3aJ8k/y8AObostBrUfN
	cu8gU2gVFW8aKwdNM43VJMV3NY2Izjkjq4xSm+v/pwis
X-Google-Smtp-Source: ACHHUZ62bkUTXKH4l9FugnyDyPcMmEXyfyB7+0pTfl1eNDIhg53cXo6gzAxIl4+jILxTe7A8dKMymw==
X-Received: by 2002:a17:907:3e92:b0:969:e88a:6071 with SMTP id hs18-20020a1709073e9200b00969e88a6071mr18329172ejc.61.1684965188901;
        Wed, 24 May 2023 14:53:08 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id e18-20020aa7d7d2000000b00513e97bf61asm322219eds.27.2023.05.24.14.53.07
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 14:53:07 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-510d6b939bfso3099705a12.0
        for <patches@lists.linux.dev>; Wed, 24 May 2023 14:53:07 -0700 (PDT)
X-Received: by 2002:a17:907:8a12:b0:93e:fa12:aa1a with SMTP id
 sc18-20020a1709078a1200b0093efa12aa1amr19427794ejc.1.1684965187067; Wed, 24
 May 2023 14:53:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-1-mcgrof@kernel.org> <20230524213620.3509138-2-mcgrof@kernel.org>
In-Reply-To: <20230524213620.3509138-2-mcgrof@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 May 2023 14:52:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
Message-ID: <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 2:36=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> Add support for a new call which allows to detect duplicate requests
> for each inode passed.

No.

This is all disgusting.

Stop adding horrific code for some made-up load that isn't real.

           Linus
