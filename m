Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16016131
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 23:06:32 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id f9so6213360qvw.11
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 16:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nBDXZy0PNI6HxH20NIcd0boi0iBLy+daKqm4xUcQcFU=;
        b=h8viMjz+y6iHBxaQsccGgC/gv+qGP1KNSL8rg/v4QcxfEnmZ9wgWx9AJSUgxsgxFJ1
         /2E5OZi80IiFljcLSosBBJxQaTgXYAOU1HzUM/GLORtvZcmDXlNTyp0cfRQQQJdkcxzo
         xgugvXpTk/iTffxwFcSe209orXG7+HVsu4M4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nBDXZy0PNI6HxH20NIcd0boi0iBLy+daKqm4xUcQcFU=;
        b=L/QQHRy0tosgOv2d03bw/LrvSPoBanlyqgVE+T1FDJ+FWGWLrVuYqAsSadY8WQdZSn
         cYGpLD9QjIOIMWumY7mTuTff29Gz6Nj4RvwOtNENvIGQQaque+KNLoW4KVE/Mgxh7oMc
         pX1C8kvnezdt17MD28gJwQGagO+fct4Az+tGVAPXZjH//8uNV1XAbn2mgfW7bPZo/mSY
         46guxQ6vU0QC6kJgF+nOnNEznEHvI1d8JqbSpIZHkYi3eWEWliH8RgU/bn14t6ePLoTP
         DzGp+D6mCYr5fWXi+QU+MJVMkReImw5GC4/EE7fV4vqa2khkQ2h/WpFsghcJUj87S165
         ZORQ==
X-Gm-Message-State: ACgBeo3zVtd3xwwPLEHSozZZckTnQr4HAyw+NGBR05FDMc7LVBH6hzc8
	x+FTkIlaTc0gpAy1pqM0v1P7x6ffcZ7drPw+m7WRxg==
X-Google-Smtp-Source: AA6agR5UHLA8tvZAhQU4iM5tHIJAg9lMspH17o8Q7wO2kO91E24epLxwG8CU0Ojl/5hTeZIy2P8e1YISSNiYUw1f4IA=
X-Received: by 2002:a05:6214:2a82:b0:499:720:509e with SMTP id
 jr2-20020a0562142a8200b004990720509emr8585137qvb.62.1661900791943; Tue, 30
 Aug 2022 16:06:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220830225831.2362403-1-swboyd@chromium.org> <20220830225831.2362403-5-swboyd@chromium.org>
In-Reply-To: <20220830225831.2362403-5-swboyd@chromium.org>
From: Prashant Malani <pmalani@chromium.org>
Date: Tue, 30 Aug 2022 16:06:20 -0700
Message-ID: <CACeCKafwySAK0Wti1PC7ZC=OjBoM96XXHMnbtAdyTMrQMz436w@mail.gmail.com>
Subject: Re: [PATCH 4/4] platform/chrome: cros_typec_switch: Inline DRV_NAME
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Tzung-Bi Shih <tzungbi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Thanks for the cleanups!

On Tue, Aug 30, 2022 at 3:58 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> This macro is only used one place, let's inline it instead to save a
> line or two.
>
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Prashant Malani <pmalani@chromium.org>
