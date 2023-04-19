Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1AF15CD
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:02:52 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-38dfa504391so916871b6e.3
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681873371; x=1684465371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qy2us3ZF8Tj2uMWYJJfvUD27ubXE3+0nUE1gRG9Duwk=;
        b=k/vAgxx03RaApkIGw+hA6V35gOL56X2LGZ0CU09W/ENxcytiBPHMnZbvII0+LGyMrZ
         M47ldLvvPyLrrBs+s/xlM4X6KHXHUnjNuvpcHI0besLf9fatk9EqJnZimdG+3h4Z60pL
         q3fwAF8j4i9oYyu4IDGjybA9416G9JfwToAfoNHfKicxpqjYAfBTHzvK6zPm2jguSGmb
         n5W6UrLfYvnm6ZkgOICc4UbNKWxR8jwuVEtryMoxbNcAylxDP1HbvbrDVZRp/BCyppmn
         rBX+PT+TedqXAguPXZHZP3h1NdX3JDsVsc+CJrD/PhVYkQLpxjIoIhAZuRoh2pz9yMFJ
         f/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681873371; x=1684465371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qy2us3ZF8Tj2uMWYJJfvUD27ubXE3+0nUE1gRG9Duwk=;
        b=XKgfAXz8w3iAq1IaJuGRO7ZprY6v6hd+hkORiH7hsv+nEm4RTxrgO3hzVldAVHFn5D
         BfbPSrzYOkWz+JUpeOMZUHpdbmdV+qZksFWAgBXRhY+DYU90ZMey8KWhYQGGn3RSn1qe
         bO1Q8VKo05dxA0Es0pUhqTgyxsYxGpq5+N+sJSDivT7S0xWN8oH5fXE4FKdY3OkZr5wA
         5KNT3J4H6+gzAl8mUiojfrOebtvuIxsDrNoMXYfFYaE7/88AkMcJZBocNlG5fdBb+rU4
         mEw/QEykCIeDv4FPLRwPQlmWHwKeLk8FAS6XelvqVAY4MyP23Bt9s6KcLzaop6kB5yw9
         BUtA==
X-Gm-Message-State: AAQBX9eurvJiCRJlVAWwBKgNnJtHcKZsKczta/1j6zCA4iwHd1VqFhKq
	a0/bedJsVojoeln0Kfk44W8=
X-Google-Smtp-Source: AKy350Y6+wITuOdfOsSOOKiQoCcAoM5PO9PRAiLdSl7AkNOZ2vuecpem+Nn85c8JloA5j/LWfiSYTg==
X-Received: by 2002:a05:6808:f86:b0:38d:e2b0:d5ea with SMTP id o6-20020a0568080f8600b0038de2b0d5eamr2209793oiw.44.1681873370896;
        Tue, 18 Apr 2023 20:02:50 -0700 (PDT)
Received: from tx3000mach.io (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id bi9-20020a056808188900b00387160bcd46sm6498859oib.46.2023.04.18.20.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:02:50 -0700 (PDT)
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
To: ojeda@kernel.org
Cc: alex.gaynor@gmail.com,
	benno.lossin@proton.me,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	gyakovlev@gentoo.org,
	jan.steffens@gmail.com,
	jistone@redhat.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	rust-for-linux@vger.kernel.org,
	wedsonaf@gmail.com,
	william.brown@suse.com
Subject: Re: [PATCH 3/3] rust: upgrade to Rust 1.68.2
Date: Wed, 19 Apr 2023 00:02:43 -0300
Message-Id: <20230419030243.540348-1-yakoyoku@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418214347.324156-4-ojeda@kernel.org>
References: <20230418214347.324156-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 4/18/23 18:43, Miguel Ojeda wrote:
> [...]

Kinda bunch to review, although may I ask if each time the `alloc`
crate is updated is worth to mention the changes upon it [1], can be
skipped otherwise.

Link: https://github.com/rust-lang/rust/commits/master/library/alloc [1]

Reviewed-By: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
