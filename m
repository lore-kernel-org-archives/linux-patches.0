Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9421871
	for <patches@lists.linux.dev>; Mon, 24 Jul 2023 10:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690196293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F6TumHjbvlMGzO4xVYnJBJFbMI9Ohdrrske9/1R3NiY=;
	b=cev9ycAickBsItKoAGqdT5qlT5o1gneS05xhjvz2H6+FZSQUt89bCKV+pg2K8y/wTQ4+LK
	bAkdgzBRU+79jslFdnFNrxpOQ0XaUIZkfM0W7w2g5IXaRYeeEmVyoYU0YsX0XTWuSvtSMD
	toEgDT4KDkMi+hklOa9Nj/whd4FT6sY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-rYGS7mNzMRe1kqLpvOnJ5A-1; Mon, 24 Jul 2023 06:58:11 -0400
X-MC-Unique: rYGS7mNzMRe1kqLpvOnJ5A-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fbb34f7224so26154625e9.2
        for <patches@lists.linux.dev>; Mon, 24 Jul 2023 03:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690196290; x=1690801090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6TumHjbvlMGzO4xVYnJBJFbMI9Ohdrrske9/1R3NiY=;
        b=SbF+7wdPPOpf7rveXIa4JQkvedAoJ6NGJLJOULyCsPk2rYJDE79ApeISCMh1foPGYv
         46WFnA1fFC/ueiUUs2cnKigY6te/Ze2Na6sXqTYmvAjfmmguniX9Q2u9w2R5y6z6UNn7
         na7POLDY8vFaQ3Oi8r/Ec5dK727Vkjy3auofEQSiTy+nYkf5yWs8fyEfUrvzbYJeGJJY
         k8uVQVKKdFVFT9aRJttm9HF3wlCVWEoW8dyQvWjZIqV6Sd2mDOPK84xe3iLjOlbQcHAf
         vGETQeqStPTX+HgccxW7T1OpuF9yCFBc1LgU6LrDvBx1RbYzYEYjvXRabCJNIM6ltuZa
         O4lQ==
X-Gm-Message-State: ABy/qLZwXgRAw+jE8rQj52KahpzaGC/d2JjQO7J3+KGI5Vx4oG0v7haj
	vBK9rtJ7V2EdfJhK0FaDPENZV3FVBqTX4AfnIf0A+7F3zQw7zZrFeQ0fzlgOOPCQLWpT/VCJgKp
	NZXwnuZu3fqTIOXA0
X-Received: by 2002:a05:600c:2116:b0:3fa:8fb1:50fe with SMTP id u22-20020a05600c211600b003fa8fb150femr7689287wml.15.1690196290620;
        Mon, 24 Jul 2023 03:58:10 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG3j1Ad2yvF+UnMLXv/6Lw2FRlTF06c6lZtWHJGzEdkPdJIwnZ5I9t8OadERNj+baxM+ax9jQ==
X-Received: by 2002:a05:600c:2116:b0:3fa:8fb1:50fe with SMTP id u22-20020a05600c211600b003fa8fb150femr7689274wml.15.1690196290272;
        Mon, 24 Jul 2023 03:58:10 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id n11-20020a7bcbcb000000b003fba92fad35sm12576469wmi.26.2023.07.24.03.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 03:58:09 -0700 (PDT)
Date: Mon, 24 Jul 2023 12:58:08 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] fstests: add helper to canonicalize devices used to
 enable persistent disks
Message-ID: <20230724105808.dxyszzkzcwf7y7od@aalbersh.remote.csb>
References: <20230720061727.2363548-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230720061727.2363548-1-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2023-07-19 23:17:27, Luis Chamberlain wrote:
> The filesystem configuration file does not allow you to use symlinks to
> devices given the existing sanity checks verify that the target end
> device matches the source.
> 
> Using a symlink is desirable if you want to enable persistent tests
> across reboots. For example you may want to use /dev/disk/by-id/nvme-eui.*
> so to ensure that the same drives are used even after reboot. This
> is very useful if you are testing for example with a virtualized
> environment and are using PCIe passthrough with other qemu NVMe drives
> with one or many NVMe drives.
> 
> To enable support just add a helper to canonicalize devices prior to
> running the tests.
> 
> This allows one test runner, kdevops, which I just extended with
> support to use real NVMe drives. The drives it uses for the filesystem
> configuration optionally is with NVMe eui symlinks so to allow
> the same drives to be used over reboots.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

