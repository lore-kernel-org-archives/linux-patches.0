Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD538A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:27:16 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id n5so12914730ljc.9
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 10:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ShU3lDY6GJI8ggbz9GikiyJz3+sZxpSyvZWgc9tJAwk=;
        b=ybAbiblUQPAF0VdFc+1XKh3mBUCtjfMA2Q/3lE3YbIJBAZXm8RbKZJZC7hHlUoHnH4
         w3Mdnk7CTO/zXp7cpQ4TTx8A+Vdwu7rTYgeQ0f8qWmcMemC6m22fMLhQzQZg8pCgYyE6
         RRlGp0P1j2p9KOcBkFTC/H4meA42m8twO1O3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ShU3lDY6GJI8ggbz9GikiyJz3+sZxpSyvZWgc9tJAwk=;
        b=bUchp60Pthku6di05cXki/Fp+ZigLu/y7sk928pbmZFlZWeFRdPeBG/W2I8X8WM/eo
         qEMhIHI+Ng9gAekn32v6JD0Io4/tbJmlJZd5LHpHMoeL1+CVRx2fuq4l0LJL56wFPL9X
         p+rVIKQ2QIS7LLYHMzfYwYvAAB7sctNKKUE5ZHggOkCXNOaI5Em/pD78fO++X80P8yDJ
         oABUCQRnTEvuniJ95iFiJTRcdUGSYnN848Xe1bu95xWEcJ6dwy2bUiqkLdSieAvCqW0Y
         yE/Bhf9IqGTHRoPlfcjYZyITWabDc9DJYO19Q/gb+3EucUxTCKkuvFKeDOzeAfuB2Fml
         ZSnQ==
X-Gm-Message-State: AFqh2kp8y23Mqzayghg4kb21tGceZ/fVH0cNOD6wQGX7dWll4AhCvthw
	tq9PnKa1RKRyLUpl7og1aru5oGBeUQnyJnu5UDoiOtp2hnf68g==
X-Google-Smtp-Source: AMrXdXt/W4AlREqzhFnGF9afSPt07wXNzsyNaFjWN07K7Haos9cvue5bZfKDEKNEzr9ityRbRBH6lLdr6w7YF9p5+S0=
X-Received: by 2002:a2e:3215:0:b0:27f:b98c:7a0e with SMTP id
 y21-20020a2e3215000000b0027fb98c7a0emr4688452ljy.356.1673375234806; Tue, 10
 Jan 2023 10:27:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230110180031.620810905@linuxfoundation.org> <20230110180033.597780936@linuxfoundation.org>
 <CAEXW_YQhoJkCNaBKRSLh5OCYn1ObA8dy63ZrgmRgpEaVorBnnQ@mail.gmail.com>
In-Reply-To: <CAEXW_YQhoJkCNaBKRSLh5OCYn1ObA8dy63ZrgmRgpEaVorBnnQ@mail.gmail.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Tue, 10 Jan 2023 13:27:02 -0500
Message-ID: <CAEXW_YQeDCfP-2cJ5Qwx5gAiPxzn4uTEqKB6m3BsCwzpM43qAA@mail.gmail.com>
Subject: Re: [PATCH 5.15 057/290] rcu-tasks: Simplify trc_read_check_handler()
 atomic operations
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 10, 2023 at 1:26 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Tue, Jan 10, 2023 at 1:23 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Paul E. McKenney <paulmck@kernel.org>
> >
> > commit 96017bf9039763a2e02dcc6adaa18592cd73a39d upstream.
>
> Thanks Greg, I had sent the same patch earlier for 5.15. Just so I
> learn, anything I did wrong or should have done differently?

Never mind, I think it is just coming from your queue after you picked
mine up...
