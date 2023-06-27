Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384F41386
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 08:42:05 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c17812e30b4so3498131276.1
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 01:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687855325; x=1690447325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1RESTY0nSCfW0d4KcpyLv7Xpk29hSjI3Ckc6/VSjxn4=;
        b=c8XIlf+3aeJrwWjkv8WOhdxbRUqNtzu1r7xryqM84sNDaZTz0rgtwU4fwyvKCSfw+V
         cKwotcy9WmTSkSA1D35NIYW2q7BOtu5c2MlZafkFnYXgxrZCjgbF9WsxmNh34B0ieWP0
         n18tsAHbC/T8dPO8Fb06HV8eCH69k2z2f+HMDJSfW2yzR5ZoKM2M579qULNi9NxPkqBx
         thT8eC5DbFnBcnhsvE8Ha+gDP29RFRwPs2RLoebi29W2qg5Hdi/ZoLZHJx4YOspsEYOE
         jAhmj3bjEW8ADu4jA5WKxCOS0fptUboAd0uNfBw+rJHKHjX/SfxEZ7SlBZtkaws7MISj
         u5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687855325; x=1690447325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1RESTY0nSCfW0d4KcpyLv7Xpk29hSjI3Ckc6/VSjxn4=;
        b=J2TBmudiIdZRHcQCjJJys8pPc6Ecu9u1gfMzS56xOPNsANbUke52NAufAo1eWatV8w
         pxZuOOdKM3e5SnnEek29Ztxs92F5HAme2s0WZB/fO98Z4avf5DWIpYpoEDBQpBY8+FXC
         QRNbNS6Q/i3XvrRY7coTOd964vOWrOfBbqVJU7JMGGqdaHQf9XyyI3l+sA5YI4SIqOjO
         68yF6xR7PkHPHIT8X8jybftT6KaccX1BzU796Ov0hzy08M1z8dWOkykeV4UUNlBApyP9
         iNomse/CxCVsQwgF+6lnpJ5nlrjYByZOHH/yUrIXKFZlFT6uO6rMyf0N4rdmOnwi2MBf
         ZuiQ==
X-Gm-Message-State: AC+VfDzPsLr3gvu/OD8eZhWSocXTp39/w/6CkjDjoJ1nTtYnpJM7CBeV
	5fPhigd+Q0t/zi3MgxRRkE3puSZjhsJ2k20=
X-Google-Smtp-Source: ACHHUZ5iOX9ZQJ8FlpbvB37RDLgsinU8s6WO100emwe5lWg59GuLkFcVXvVuPSp2u0spSRurCuI1z9UcFOaU4po=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:6988:0:b0:c1d:4fce:460 with SMTP id
 e130-20020a256988000000b00c1d4fce0460mr2519491ybc.4.1687855325036; Tue, 27
 Jun 2023 01:42:05 -0700 (PDT)
Date: Tue, 27 Jun 2023 08:42:02 +0000
In-Reply-To: <sEZfLlqyui7bU5IsD7mRZq4wIsJqQ5ZZj4qtp6oq-d8rEu4Gx1rp6MXwxTsZt4zEaO7V-5HtmmULgwpVArU4DW-9UcZsjWYg0a5pojvAlVQ=@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <sEZfLlqyui7bU5IsD7mRZq4wIsJqQ5ZZj4qtp6oq-d8rEu4Gx1rp6MXwxTsZt4zEaO7V-5HtmmULgwpVArU4DW-9UcZsjWYg0a5pojvAlVQ=@proton.me>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627084202.1738047-1-aliceryhl@google.com>
Subject: Re: [PATCH v2 5/8] rust: workqueue: add helper for defining
 work_struct fields
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Benno Lossin <benno.lossin@proton.me> writes:
> On 01.06.23 15:49, Alice Ryhl wrote:
>> +/// # Safety
>> +///
>> +/// The [`OFFSET`] constant must be the offset of a field in Self of type [`Work<T, ID>`]. The methods on
>> +/// this trait must have exactly the behavior that the definitions given below have.
> 
> I think you should just say "implementers are not allowed to implement
> the functions defined by this trait." I see no reason to allow that, since
> all functions are fully determined by the `OFFSET` constant.
 
The macro overrides one of the methods, so that wont work.
(It overrides the method to check that the field has the claimed type.)

I'll apply the rest of your suggestions.

Alice

