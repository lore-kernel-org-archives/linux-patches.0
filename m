Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C948E1F5424;
	Thu, 12 Jun 2025 07:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749712983; cv=none; b=SxeeTw5lcnIGbvuJRHDRD+Ks/2Z51neS9brFdxAB0N46yU5OHaVWjHlvHikES6dRn2vY0lYhEygU3fBLyZpA6Vi/Ux/IU/RsqnYKAz8VnFBvLR+IpLUBo3Cik+XePm1UT6myR1falqkX+IIfA+fb1yna0vMtn4mzU5SJU5waYZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749712983; c=relaxed/simple;
	bh=dlPN21CVUBErePf9xinJB149BiY9qZlgWt5xnJNachg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pZtFt1p+QV+NwYUwPgLPSznH63VQ45XSGyU7yWzbl+LCNMvLizuaM3u0D/rMsz1WEwIDqSbYzfTcJPW/FTHeQumRJ+saxXI5Tna6C6qZSJw2oryeya8t56KLxWXjDjyh+mhCN4tpqvTdMLlGFqRtSS2+E2woE967R+QmFJnVQZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fuW7oxnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fuW7oxnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16138C4CEEA;
	Thu, 12 Jun 2025 07:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749712983;
	bh=dlPN21CVUBErePf9xinJB149BiY9qZlgWt5xnJNachg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fuW7oxndcGLCcwnniKw5Ai6dpH2r7+5ySzxFZio5P4aMtnIgIiyJj2Gt54LKLa6i9
	 XEHYGllblQfk0rdh0MuZTn9C+w2Uk36dniCvqkVbVNTmBdyDt9xzRIrmBcZX6p7p6I
	 MByEiD9hH+YjDy2pe2fnCI0jjhAj7eZ7znj9RX5o+I5Mbz7dVTEEld0qgoBSgYyYy7
	 /hHNPClE+MoL5zyBVjILbIH00jFio28Kn08sdgbp+5nOC+zsfwTYAHbWBT/F/pEFw0
	 9XeIqwabLfIMB1GQakvGmX+Sl0rtMOFIeWAflzfq8uyjXpuTwoPSEoGg3nuCZB0NnP
	 It88yuyVanhyA==
Message-ID: <5c210121-c9b8-4458-b1ad-0da24732ac72@kernel.org>
Date: Thu, 12 Jun 2025 09:23:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 05/34] ACPICA: Apply ACPI_NONSTRING in more places
To: Collin Funk <collin.funk1@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Ahmed Salem <x0rw3ll@gmail.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
References: <87ecvpcypw.fsf@gmail.com>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <87ecvpcypw.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12. 06. 25, 7:31, Collin Funk wrote:
> Hi Greg,
> 
> Sorry for the exta mail. Accidently put CC emails in the subject...
> 
>> --- a/tools/power/acpi/tools/acpidump/apfiles.c
>> +++ b/tools/power/acpi/tools/acpidump/apfiles.c
>> @@ -103,7 +103,7 @@ int ap_open_output_file(char *pathname)
>>   
>>   int ap_write_to_binary_file(struct acpi_table_header *table, u32 instance)
>>   {
>> -	char filename[ACPI_NAMESEG_SIZE + 16];
>> +	char filename[ACPI_NAMESEG_SIZE + 16] ACPI_NONSTRING;
>>   	char instance_str[16];
>>   	ACPI_FILE file;
>>   	acpi_size actual;
> 
> This one seems incorrect, as I was alerted to by the following warning:
> 
>      apfiles.c: In function ‘ap_write_to_binary_file’:
>      apfiles.c:137:9: warning: ‘__builtin_strlen’ argument 1 declared attribute ‘nonstring’ [-Wstringop-overread]
>        137 |         strcat(filename, FILE_SUFFIX_BINARY_TABLE);
>            |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      apfiles.c:106:14: note: argument ‘filename’ declared here
>        106 |         char filename[ACPI_NAMESEG_SIZE + 16] ACPI_NONSTRING;
>            |              ^~~~~~~~
> 
> The 'strcat' function is only well defined on NUL-terminated
> strings. Also, there is a line of code:
> 
>      filename[ACPI_NAMESEG_SIZE] = 0;
> 
> That also makes me think it is a string.

Ugh, indeed.

FTR this is about 70662db73d54 ("ACPICA: Apply ACPI_NONSTRING in more 
places").

To me neither the above, nor struct acpi_db_execute_walk's:
   char name_seg[ACPI_NAMESEG_SIZE + 1] ACPI_NONSTRING;
is correct in the commit.

This is broken in upstream/-next too.

thanks,
-- 
js
suse labs
