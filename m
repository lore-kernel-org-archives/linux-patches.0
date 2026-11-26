Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795673991;
	b=J4kClOeRcQep7ZKV1xReMzCJNvrDawhzJjph6fReylnZjXuFteOaIAxLgN5KpItIlNpS
	 2CPf9yTQtK236nKgQ7zRRLXjeEVt1uz2hQczmTAbv/jl8rM2S+M/Z2n2T7V8WEMjaauFD
	 OSrtKw8dlqs4sn4vVK/E1CunFLbOMhWEjRZnhfJdQZKCK+M1cFkIb1p7q33zvS+d5cpHV
	 C+4oqAugpzuxj/N82MR8MDpu/1Lop+DcFe2b5T6JgZF6IPdINVhKjxnK+UxZeFsja3up5
	 t3FrSsIlLGLrR+xzevRvDGiFXQnxSr9PjSmtVtZ4/bhmRzk4ijj+VWJ0TQRMvltfVGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795673991;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=blLPPs0Dr95UlcGzssFbmiXCBdXBEUBorM0KhGn8BDA=;
	b=My/eoQXhKV7//P4Wb62MHaW+6+lB2j1EoAr+/J85XDin23JrP+iBvj445OUAWZKfwl3d
	 a18d453D6gH8lsmoU950ewG9W29N89bHTzxMEUtuCyZ0bmIaDzBImZy+PRXQdxqYmdvkD
	 /0MHX4AOjbW8c8GkVDuo09RD5yOlon/QUgMgRcXJxaMheTmz60InpSFd8h6JbJYIGDRIT
	 jXqDxEcJ7Aiin9N0k4afnUMZDxT68Jx5ObSGTTtvNlzAj8cgDPavxG4woVRq2wXCym6fQ
	 rSaNh2r9O3h8wkUfBr0USNvaDN4xf20XI60BZGKXW5JqxRCX1v62lb6YDrf7EaOHiMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gv8VRVYm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7E4606A32C;
	Thu, 26 Nov 2026 06:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gv8VRVYm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9A51F000D0;
	Thu, 26 Nov 2026 06:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795673990;
	bh=blLPPs0Dr95UlcGzssFbmiXCBdXBEUBorM0KhGn8BDA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gv8VRVYm7oVDx5FcsIdkO2qfmuUM6xnz9tnAM0JyVSOWeAfPxZ0As/1JkUsw1gg7d
	 aaECfFfuNbzr2C7fXXYFIk6aMiwKxwLnhqMmAVFtkuZTSD8CEI9RKhnE7tAyvYq+LV
	 RdofnQ9tjf75SjLLgwNv0p1h9NGkRSquT6mmKMM0QeqDdO1+EgFPkVqG+JWYpadsVA
	 JBTVLIHG1v8ui3t5LKMWXomrH+7DD7FjJEyjGPZDOUKFioH7SnRRWZqu8c6ed897pF
	 23gRmmxHYFcrtt9yfAMk/hHXxSnJaWO5b4QBc7iTLuCUKzifurAk8fwW0z1bmV74Ko
	 /bo8T1yrcn+yQ==
Message-ID: <0782adf7-20af-45a3-a09b-2a34c76afbac@kernel.org>
Date: Thu, 26 Nov 2026 07:19:47 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an
 SCX_TASK_READY task
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Rahad Bhuiya <rahadbhuiya2021@gmail.com>,
 Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143830.189554233@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261125143830.189554233@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
> 
> [ Upstream commit 564405c424f49d70b13debe7fe5b550234ad6b84 ]
...
> --- a/kernel/sched/ext/ext.c
> +++ b/kernel/sched/ext/ext.c
> @@ -4198,6 +4198,7 @@ void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p)
>   		args.cancelled = true;
>   		break;
>   	case SCX_TASK_READY:
> +		scx_reset_task_fields(task_rq(p), p);

This fails to build:
../kernel/sched/ext/ext.c:4223:17: error: implicit declaration of 
function ‘scx_reset_task_fields’; did you mean ‘scx_set_task_sched’?

>   		break;
>   	case SCX_TASK_ENABLED:
>   		scx_disable_task(sch, p);

-- 
js
suse labs

