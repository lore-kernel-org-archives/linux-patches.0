Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456DA6FA6
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jsperbeck.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a5kfxfQQ"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d8486b5e780so5560257276.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 10:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698169676; x=1698774476; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:user-agent:references:precedence
         :mime-version:list-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0c4QkhNuHErh8vnB6ChFrCm3e+tU3ezPAwwcw5B29YE=;
        b=a5kfxfQQnzd98YGm2riqjOAR6oe8OrfCyZjasioa+dsreFSsAq5Q1Pfmqo1Upw+f6m
         kQjRIwBfIjjDWSVZbkuZ6579Rez1cTwS5yLHQ90x+iY+4QjffztOcT949ftYEyUcHqPC
         Jp2ZKjdVav0d6DdLi32fQpEVldoT06ySPYiiKjy4KED6PN9qbD8xxqJIbtFZ6f/y62E7
         eGEPRcRDJgLaN2TwGjRXU9CCG0qQwvoMpHGfIJqGruWyvNNqHlwb63iqasjSk13OZ9uZ
         w4spIat8aSAXQkDAfut8F495IBOY9OM/w1WUIsZWW0csto0hei1scXXxOdsXccp/pV45
         98hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698169676; x=1698774476;
        h=cc:to:from:subject:message-id:user-agent:references:precedence
         :mime-version:list-id:in-reply-to:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0c4QkhNuHErh8vnB6ChFrCm3e+tU3ezPAwwcw5B29YE=;
        b=NpVGZVYij240Ohb0XeZL7sDvLbKoR+dKpafLaYif2yxPV32Y3IGzKohJK690yog7/J
         qZDKZi1ATjwSBWHr6ogkGLPzNeR/RgziB7Goyc7+lYagb51jP7O8/kQQ8kxzjiyRDM/3
         q/0fEg3AHD/FCpAC+UmWQDqKUyC+ZAP/uV1brZRphAMCWlo1QaCwa+Newi6I/8glR5/M
         9rb3PZ4uOXQCAp2hhj8zgdBBwrYhLdmnQsn3pjyucH19dX4CCkycoukWTlFHi13O/tZl
         zKdz+XLaGuIkI4XKORlqT9AipH5lquisEzlJuiwHqXSactpdcNHW1UClXeI1Q6iQILgt
         F8LA==
X-Gm-Message-State: AOJu0Yze19oLAsMrNj5377kJRqoL5mrcaQmQaImWZ8VMiwWEO+Yg2LCy
	t+hykChzY9oNKjKQAPbAjnkGG7avTE/9gtM=
X-Google-Smtp-Source: AGHT+IGFjqrHzGS7rO/4iWFN+lUl1VP4T64lee+R1TmhPu+jMvoGaCYCgv3cQTaWsWzXBdl81WqTG1XWgd4Pv2Q=
X-Received: from jsperbeck7.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:26dc])
 (user=jsperbeck job=sendgmr) by 2002:a05:6902:b03:b0:da0:3dd2:5b02 with SMTP
 id ch3-20020a0569020b0300b00da03dd25b02mr47380ybb.1.1698169676117; Tue, 24
 Oct 2023 10:47:56 -0700 (PDT)
Date: Tue, 24 Oct 2023 17:47:54 +0000
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
List-Id: <stable.vger.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Precedence: bulk
References: <20230824170617.074557800@linuxfoundation.org>
User-Agent: quilt/0.67
X-Mailer: git-send-email 2.42.0
X-Mailing-List: stable@vger.kernel.org
X-Patchwork-Hint: ignore
X-Stable: review
Message-ID: <20230824170623.040455914@linuxfoundation.org>
Subject: [PATCH 5.10 134/135] objtool/x86: Fixup frame-pointer vs rethunk
From: John Sperbeck <jsperbeck@google.com>
To: gregkh@linuxfoundation.org
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev, 
	peterz@infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20231024174754.wEvQDuPkaO9FeOAvJjF9y1BFpabQi6JLjE82di8-1OA@z>

> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit dbf46008775516f7f25c95b7760041c286299783 upstream.
> 
> For stack-validation of a frame-pointer build, objtool validates that
> every CALL instruction is preceded by a frame-setup. The new SRSO
> return thunks violate this with their RSB stuffing trickery.
> 
> Extend the __fentry__ exception to also cover the embedded_insn case
> used for this. This cures:
> 
>   vmlinux.o: warning: objtool: srso_untrain_ret+0xd: call without frame pointer save/setup
> 
> Fixes: 4ae68b26c3ab ("objtool/x86: Fix SRSO mess")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Link: https://lore.kernel.org/r/20230816115921.GH980931@hirez.programming.kicks-ass.net
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  tools/objtool/check.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -2079,12 +2079,17 @@ static int decode_sections(struct objtoo
>  	return 0;
>  }
>  
> -static bool is_fentry_call(struct instruction *insn)
> +static bool is_special_call(struct instruction *insn)
>  {
> -	if (insn->type == INSN_CALL &&
> -	    insn->call_dest &&
> -	    insn->call_dest->fentry)
> -		return true;
> +	if (insn->type == INSN_CALL) {
> +		struct symbol *dest = insn->call_dest;
> +
> +		if (!dest)
> +			return false;
> +
> +		if (dest->fentry)
> +			return true;
> +	}
>  
>  	return false;
>  }
> @@ -2958,7 +2963,7 @@ static int validate_branch(struct objtoo
>  			if (ret)
>  				return ret;
>  
> -			if (!no_fp && func && !is_fentry_call(insn) &&
> +			if (!no_fp && func && !is_special_call(insn) &&
>  			    !has_valid_stack_frame(&state)) {
>  				WARN_FUNC("call without frame pointer save/setup",
>  					  sec, insn->offset);
> 
> 
> 

We still see the 'srso_untrain_ret+0xd: call without frame pointer save/setup' warning with v5.15.136.  It looks like the backport might be incomplete.  Is this additional change needed?

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 36ad0b6b94a9..c3bb96e5bfa6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2202,7 +2202,7 @@ static bool is_special_call(struct instruction *insn)
 		if (!dest)
 			return false;
 
-		if (dest->fentry)
+		if (dest->fentry || dest->embedded_insn)
 			return true;
 	}
 
