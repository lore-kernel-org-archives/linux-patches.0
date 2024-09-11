Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B6916D9DF
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 09:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726046826; cv=none; b=UoVnTbJsXECgRC3oJQ6eXgsNbHzzhQ4aPMKplyLoSEIKKAW2gg/ZiT+NWF1JyuEyBUWAtTlrMYvMRszObKlX+aW6j8hPwTfjPgHuhQVNWbn5dzNJcoGuc5GqCazbiMfsrIwEkFSVTafACmmgu3mt0ddaWQlQHhcxAXU41SOFrNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726046826; c=relaxed/simple;
	bh=GyWq/98TjEtVM/W1wAs9O1yLGESTt0kImb7E2rBHU+E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MUTAxCb5zSVAdRhbzt7ao6uDCtCgptDXmnFvQwOsRDwc8487NPbwH9VNa8Br6sXAmNekQUw5YsHGVhfeq9Y55G2TUZC4nYo/Z7zpUIX4phoFgeAZ7f7hI7YB/ZVThBd/Ol2x9DwS8a/VqgVe/7dHT+Q9WaAGXnRzb3SdmOYZOB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a0459a8a46so26581105ab.3
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 02:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726046824; x=1726651624;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQxVkx26ZzumOnlrOYUsyrJ7x6Xp+WsLa+JYdfrCMw0=;
        b=VIdYsaZoIMJGGFvkJ+xRfdRezZdoLIDrO8lhve8flwH+tsG95aHxYyIzxjF1n5LVtU
         jwJfpluoU3XAm7VXICpXLdMNujpMViByMDfo5niSZJ2x7/6OzCfGIHK5jSZq5pl89mYl
         O8agws7oCsL0IRjmphrpOvMslGFoPLqUjQFe6zD7XmFK2mKuB7DpdMWR8B4OLQQfQ+Sh
         5VzYOwEfi8rINLnHeTkbSiYEDAO++tkUrSYo+bsV4cBwn0lgyAcu/bH8Cmkts7oEFlt/
         bfVmSujm0vtyZeNnrFS6SIqWWlPxbikupAbgxoarcPeIrfg5v/zI/PgTyzj7RP0sC4Cd
         fHEA==
X-Forwarded-Encrypted: i=1; AJvYcCX0nKT7dXiIiTRDeMDPQ1nlitq7XBGDHm81Y650VTFw1U7PXvPgNkZdT2WATpanrRbaWxqJVlTq@lists.linux.dev
X-Gm-Message-State: AOJu0YxXJ0a2au4soiwlid1I+Eh+lZ/EzCFQ2LHIWvioP++dO18hkHms
	L9t3AoTogQ1eDbLLAXadZUCcMrOQi0FK/aXF8mZ2Cugvs5zsjxBt7jGHHsKCgo+smFf1+229EUP
	ByFbR4KeDtjQPCacBYKF99yVORCeVhiRUuXZseFQtijGfjI/mOfApxpc=
X-Google-Smtp-Source: AGHT+IE4VldLLWN6bhbZLZOQgPzhE/VUqLjk7ZIIq9A/SorHWx0n9L1p/6kGh/kAVA9lzMkPQ0j/leN4cM/KZaqF+5v9MIdYYo7+
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca05:0:b0:39b:3e01:cbd4 with SMTP id
 e9e14a558f8ab-3a0742302e7mr27823375ab.14.1726046824195; Wed, 11 Sep 2024
 02:27:04 -0700 (PDT)
Date: Wed, 11 Sep 2024 02:27:04 -0700
In-Reply-To: <20240911090609.339939-2-matttbe@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d273bb0621d497b1@google.com>
Subject: Re: [syzbot] [mptcp?] possible deadlock in sk_clone_lock (3)
From: syzbot <syzbot+f4aacdfef2c6a6529c3e@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, matttbe@kernel.org, patches@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f4aacdfef2c6a6529c3e@syzkaller.appspotmail.com
Tested-by: syzbot+f4aacdfef2c6a6529c3e@syzkaller.appspotmail.com

Tested on:

commit:         8d8d276b Merge tag 'trace-v6.11-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b407c7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=f4aacdfef2c6a6529c3e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1292a49f980000

Note: testing is done by a robot and is best-effort only.
