Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0624013AFA
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 08:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695025202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=92wzAdKARWFR1c6z08RRnVQAy9ahIVkHGLAopnGDnOw=;
	b=VjVRPomS/woh9EFEG1IT95SZolUxdypLUAMJ+QchTtVQ+RywuWUggYHz/MAfa2iLyIOs2m
	FmIsbsGzFOjqmeQ1jHAvFv537Lpu1fhJrjJSvPLo49aoKX8asiJfo4aNEsSfoQZKmFKjqw
	OcDBQqgNCHYJfQu622a3iuh4J/loEQ8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-t5ArqiPpPOqu0rdWCCFUWA-1; Mon, 18 Sep 2023 04:20:01 -0400
X-MC-Unique: t5ArqiPpPOqu0rdWCCFUWA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-573c84224easo4208515a12.1
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 01:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695025200; x=1695630000;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92wzAdKARWFR1c6z08RRnVQAy9ahIVkHGLAopnGDnOw=;
        b=WydfG7UZEG2P0UycYKWM/6BRHtD/9yyEZCljYT1qkF7/yyVBXwMcGQXNs9S37LhvMU
         7/bVjr4kvyqrzRHAUUgsdK4BPRRZ8n6UsoCvF5RvHsORZ+0uhQBpklDCNRMgQse/CVmg
         UcoyL/3ahZ6aMU3FWdDljaHaJjjPlnWcKIn+nM+OI3e/7hx/rDXFDHioN/KzJ29QXETM
         pyFajMKOoI4vM+DVXn+DuuIsdrfPxiTKdG6vHjsyvGKiyX9xTGpjqng4GUIRX2GeR7pa
         CSQOY65z/z0BkI3UEAAodmaKe4KBE3a2+hySD3sovnnxx2EbjYGbke6tfJNdGnAJNxuQ
         90yg==
X-Gm-Message-State: AOJu0YxqsamPNLswB4pNldgbjy/Y/QZpgfklhEr3m9oO/VUBN1T2vYeJ
	JFrkM4qtBhL7uAv33r287CYJXdNIJCcto5VjyKX+kaKPCk9b01BghuLiyfik5ZivlwRpnWx+mEp
	sIiDE9vgzgFHkqtKoKw==
X-Received: by 2002:a05:6a20:4285:b0:14d:d9f8:83f8 with SMTP id o5-20020a056a20428500b0014dd9f883f8mr12432607pzj.1.1695025200322;
        Mon, 18 Sep 2023 01:20:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxmpu9aYsRH5PxKSMAcSl9CDsjK7X4TfEGbL7f9zA4TKZjAXWxmPgjFksiqXL0FWkoWy1VwA==
X-Received: by 2002:a05:6a20:4285:b0:14d:d9f8:83f8 with SMTP id o5-20020a056a20428500b0014dd9f883f8mr12432594pzj.1.1695025200019;
        Mon, 18 Sep 2023 01:20:00 -0700 (PDT)
Received: from [10.72.113.158] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 10-20020aa7910a000000b0068890c19c49sm6698109pfh.180.2023.09.18.01.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 01:19:59 -0700 (PDT)
Message-ID: <90c74084-d3dc-e1cf-0d9a-a244529f7779@redhat.com>
Date: Mon, 18 Sep 2023 16:19:55 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.5 113/285] ceph: make members in struct
 ceph_mds_request_args_ext a union
To: Ilya Dryomov <idryomov@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Milind Changire <mchangir@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20230917191051.639202302@linuxfoundation.org>
 <20230917191055.579497834@linuxfoundation.org>
 <CAOi1vP9Mh02NB4-n5Wy3Zs1Y8M33qJsZzd12Y6k991jubQVzwQ@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9Mh02NB4-n5Wy3Zs1Y8M33qJsZzd12Y6k991jubQVzwQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/18/23 16:04, Ilya Dryomov wrote:
> On Sun, Sep 17, 2023 at 9:49 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> 6.5-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> [ Upstream commit 3af5ae22030cb59fab4fba35f5a2b62f47e14df9 ]
>>
>> In ceph mainline it will allow to set the btime in the setattr request
>> and just add a 'btime' member in the union 'ceph_mds_request_args' and
>> then bump up the header version to 4. That means the total size of union
>> 'ceph_mds_request_args' will increase sizeof(struct ceph_timespec) bytes,
>> but in kclient it will increase the sizeof(setattr_ext) bytes for each
>> request.
>>
>> Since the MDS will always depend on the header's vesion and front_len
>> members to decode the 'ceph_mds_request_head' struct, at the same time
>> kclient hasn't supported the 'btime' feature yet in setattr request,
>> so it's safe to do this change here.
>>
>> This will save 48 bytes memories for each request.
>>
>> Fixes: 4f1ddb1ea874 ("ceph: implement updated ceph_mds_request_head structure")
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> Reviewed-by: Milind Changire <mchangir@redhat.com>
>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   include/linux/ceph/ceph_fs.h | 24 +++++++++++++-----------
>>   1 file changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index 49586ff261520..b4fa2a25b7d95 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -462,17 +462,19 @@ union ceph_mds_request_args {
>>   } __attribute__ ((packed));
>>
>>   union ceph_mds_request_args_ext {
>> -       union ceph_mds_request_args old;
>> -       struct {
>> -               __le32 mode;
>> -               __le32 uid;
>> -               __le32 gid;
>> -               struct ceph_timespec mtime;
>> -               struct ceph_timespec atime;
>> -               __le64 size, old_size;       /* old_size needed by truncate */
>> -               __le32 mask;                 /* CEPH_SETATTR_* */
>> -               struct ceph_timespec btime;
>> -       } __attribute__ ((packed)) setattr_ext;
>> +       union {
>> +               union ceph_mds_request_args old;
>> +               struct {
>> +                       __le32 mode;
>> +                       __le32 uid;
>> +                       __le32 gid;
>> +                       struct ceph_timespec mtime;
>> +                       struct ceph_timespec atime;
>> +                       __le64 size, old_size;       /* old_size needed by truncate */
>> +                       __le32 mask;                 /* CEPH_SETATTR_* */
>> +                       struct ceph_timespec btime;
>> +               } __attribute__ ((packed)) setattr_ext;
>> +       };
> Hi Xiubo,
>
> I was going to ask whether it makes sense to backport this change, but,
> after looking at it, the change seems bogus to me even in mainline.  You
> added a union inside siting memory use but ceph_mds_request_args_ext was
> already a union before:
>
>      union ceph_mds_request_args_ext {
>          union ceph_mds_request_args old;
>          struct { ... } __attribute__ ((packed)) setattr_ext;
>      }
>
> What is being achieved here?

As I remembered there has other changes in this union in the beginning. 
And that patch seems being abandoned and missing this one.

Let's skip backporting this one and in the upstream just revert it.

Thanks

- Xiubo

>      union ceph_mds_request_args_ext {
>          union {
>              union ceph_mds_request_args old;
>              struct { ... } __attribute__ ((packed)) setattr_ext;
>          };
>      }
>
> Thanks,
>
>                  Ilya
>

