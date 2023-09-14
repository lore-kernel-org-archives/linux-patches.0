Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70724224F7
	for <patches@lists.linux.dev>; Thu, 14 Sep 2023 08:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1694681586; x=1726217586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:reply-to:mime-version:
   content-transfer-encoding;
  bh=1oOQuxfNU4RfdzAwsBikNi3NOnwfshCWMLL8S7/JsUg=;
  b=g0D1px38MZ4zHjcn9JAbFoKMzanM+0sSb/KKzqUaBAi15nnH0MGCLZde
   q2CVl9I7sm7N9bf7jfMTic0oNYf55qgrV01IKNgYv5AOG7q/MeHPwV2l9
   fvnqoUlE+WZNvTNQHAKgljBBnGg0xs/DA1KIu3JdHTLOc1qiyQhFRTO4l
   w=;
X-IronPort-AV: E=Sophos;i="6.02,145,1688428800"; 
   d="scan'208";a="358488597"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 08:53:03 +0000
Received: from EX19D017EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id C8143810F0;
	Thu, 14 Sep 2023 08:53:00 +0000 (UTC)
Received: from dev-dsk-gerhorst-1c-a6f23d20.eu-west-1.amazon.com
 (10.15.21.113) by EX19D017EUA004.ant.amazon.com (10.252.50.239) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Thu, 14 Sep
 2023 08:52:56 +0000
From: Luis Gerhorst <gerhorst@amazon.de>
To: <gregkh@linuxfoundation.org>
CC: <alexei.starovoitov@gmail.com>, <ast@kernel.org>, <eddyz87@gmail.com>,
	<laoar.shao@gmail.com>, <patches@lists.linux.dev>, <stable@vger.kernel.org>,
	<yonghong.song@linux.dev>, <hagarhem@amazon.de>, <puranjay12@gmail.com>,
	<daniel@iogearbox.net>, Luis Gerhorst <gerhorst@amazon.de>
Subject: Re: [PATCH 6.1 562/600] bpf: Fix issue in verifying allow_ptr_leaks
Date: Thu, 14 Sep 2023 08:51:32 +0000
Message-ID: <20230914085131.40974-1-gerhorst@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911134650.200439213@linuxfoundation.org>
References: <20230911134650.200439213@linuxfoundation.org>
Reply-To: <gerhorst@cs.fau.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Originating-IP: [10.15.21.113]
X-ClientProxiedBy: EX19D033UWC003.ant.amazon.com (10.13.139.217) To
 EX19D017EUA004.ant.amazon.com (10.252.50.239)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> 6.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
> 
> From: Yafang Shao <laoar.shao@gmail.com>
> 
> commit d75e30dddf73449bc2d10bb8e2f1a2c446bc67a2 upstream.

I unfortunately have objections, they are pending discussion at [1].

Same applies to the 6.4-stable review patch [2] and all other backports.

[1] https://lore.kernel.org/bpf/20230913122827.91591-1-gerhorst@amazon.de/
[2] https://lore.kernel.org/stable/20230911134709.834278248@linuxfoundation.org/

-- 
Luis



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



