Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5930C53814;
	Mon,  1 Apr 2024 20:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712001639; cv=none; b=H1Ypb7bulSd+IbEouPzeMmMpy/1RReEYQjYLFhkkdRLG9BmTY60sEhgTPFy07T+PSmvSFl4TbjlXzIPIpNdhXVhzxFIL7/5SrhMqSh9iz8NuxDOo7T0sYBMMshI9KzRe/XWQpUoYvKOHEe1dExRSlW8L37+rqCTJ1g5RggK3VRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712001639; c=relaxed/simple;
	bh=HvqsN/+ZvRcomEjUuRAlTJ8FF83yVQU91ypj9PDw9n8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=L+42RTugQZPEoV8ypdfqyDgXof5At/YTRGL5DpIZTWEZo8iSoGc+7Sc6XwkuBofoE/DE+Qi+HUFbYjN2/ZqJy78/yZ69+9BT98g3ql7amipOyAE3UDJP4OE4vQlcWLY81FQ5mWT+pVMRi7zSGDDU7RxCXav19qqkMZMuFq5heLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfvdjha0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfvdjha0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B53F9C43394;
	Mon,  1 Apr 2024 20:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712001638;
	bh=HvqsN/+ZvRcomEjUuRAlTJ8FF83yVQU91ypj9PDw9n8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jfvdjha0oM68m0sHHWXDGFlL8sV2abkotTtlnUXqMv+OTfOZqC8M4+rUXb+YR7u/R
	 pWnihe2Bchmh569KS+w8g82RRdv8aegKiJfSRzfLbtk2pux351rRllic+98VairPn6
	 I54kgm05K4pmlhb/ZdQ+DBeZYBGt3QADKBbW2utq90PbrtYt3ogQD1y3aPYtBoM79S
	 d62tKmsUq2FsEfFZMyNqy8XwB4hFqpEfQ9trmeQk8pDXbx1f1kZz8Jjq+M5JXpjbww
	 jH0fZl7jjG4J887AUjTwu0QjS/fOGJNf0PDXDkB/tQH9iXH6Vdosc3ydPOYLvQOyK9
	 XVn7PBHs8Xr7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A644BD9A154;
	Mon,  1 Apr 2024 20:00:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bluetooth] Bluetooth: Fix type of len in
 {l2cap,sco}_sock_getsockopt_old()
From: patchwork-bot+bluetooth@kernel.org
Message-Id: 
 <171200163867.25745.13498773168587427882.git-patchwork-notify@kernel.org>
Date: Mon, 01 Apr 2024 20:00:38 +0000
References: <20240401-bluetooth-fix-len-type-getsockopt_old-v1-1-c6b5448b5374@kernel.org>
In-Reply-To: <20240401-bluetooth-fix-len-type-getsockopt_old-v1-1-c6b5448b5374@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
 ndesaulniers@google.com, morbo@google.com, justinstitt@google.com,
 keescook@chromium.org, linux-bluetooth@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, stable@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon, 01 Apr 2024 11:24:17 -0700 you wrote:
> After an innocuous optimization change in LLVM main (19.0.0), x86_64
> allmodconfig (which enables CONFIG_KCSAN / -fsanitize=thread) fails to
> build due to the checks in check_copy_size():
> 
>   In file included from net/bluetooth/sco.c:27:
>   In file included from include/linux/module.h:13:
>   In file included from include/linux/stat.h:19:
>   In file included from include/linux/time.h:60:
>   In file included from include/linux/time32.h:13:
>   In file included from include/linux/timex.h:67:
>   In file included from arch/x86/include/asm/timex.h:6:
>   In file included from arch/x86/include/asm/tsc.h:10:
>   In file included from arch/x86/include/asm/msr.h:15:
>   In file included from include/linux/percpu.h:7:
>   In file included from include/linux/smp.h:118:
>   include/linux/thread_info.h:244:4: error: call to '__bad_copy_from' declared with 'error' attribute: copy source size is too small
>     244 |                         __bad_copy_from();
>         |                         ^
> 
> [...]

Here is the summary with links:
  - Bluetooth: Fix type of len in {l2cap,sco}_sock_getsockopt_old()
    https://git.kernel.org/bluetooth/bluetooth-next/c/2216e1eabc7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


